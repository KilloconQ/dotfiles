---
name: nest-11
description: >
  NestJS 11 patterns and best practices.
  Trigger: When building NestJS backend - modules, controllers, services, guards, pipes.
license: Apache-2.0
metadata:
  author: prowler-cloud
  version: "1.0"
---

## Module Structure (REQUIRED)

```typescript
// ✅ ALWAYS: Feature module with controllers, providers, exports
@Module({
  imports: [DatabaseModule],
  controllers: [UsersController],
  providers: [UsersService],
  exports: [UsersService], // expose to other modules
})
export class UsersModule {}

// ✅ Global module — available everywhere without importing
@Global()
@Module({
  providers: [ConfigService],
  exports: [ConfigService],
})
export class ConfigModule {}

// ✅ Dynamic module with forRoot/forRootAsync
@Module({})
export class DatabaseModule {
  static forRoot(options: DbOptions): DynamicModule {
    return {
      module: DatabaseModule,
      providers: [
        { provide: 'DB_OPTIONS', useValue: options },
        DatabaseService,
      ],
      exports: [DatabaseService],
    };
  }

  static forRootAsync(options: {
    useFactory: (...args: any[]) => Promise<DbOptions> | DbOptions;
    inject?: any[];
    imports?: any[];
  }): DynamicModule {
    return {
      module: DatabaseModule,
      imports: options.imports || [],
      providers: [
        { provide: 'DB_OPTIONS', useFactory: options.useFactory, inject: options.inject || [] },
        DatabaseService,
      ],
      exports: [DatabaseService],
    };
  }
}

// ❌ NEVER: Everything in AppModule, circular module dependencies
```

**Why?** Feature modules keep the codebase organized. Dynamic modules allow configuration at import time.

## Controllers (REQUIRED)

```typescript
@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  // ✅ Route + param decorators, return objects directly
  @Get()
  findAll(@Query('role') role?: string): Promise<User[]> {
    return this.usersService.findAll(role);
  }

  @Get(':id')
  findOne(@Param('id', ParseUUIDPipe) id: string): Promise<User> {
    return this.usersService.findOne(id);
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  create(@Body() dto: CreateUserDto): Promise<User> {
    return this.usersService.create(dto);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() dto: UpdateUserDto): Promise<User> {
    return this.usersService.update(id, dto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  remove(@Param('id') id: string): Promise<void> {
    return this.usersService.remove(id);
  }

  // ❌ NEVER: @Res() bypasses interceptors, serialization, and exception filters
  @Get('bad')
  bad(@Res() res: Response) {
    res.json({ data: 'breaks NestJS pipeline' });
  }
}
```

**Why?** Returning objects lets NestJS handle serialization, status codes, and interceptors automatically. Use `@Res()` only for streaming/SSE.

## Services & Dependency Injection (REQUIRED)

```typescript
// ✅ Injectable service — singleton by default
@Injectable()
export class UsersService {
  constructor(
    private readonly usersRepo: UsersRepository,
    private readonly configService: ConfigService,
  ) {}

  findAll(role?: string): Promise<User[]> {
    return this.usersRepo.find(role ? { where: { role } } : {});
  }
}

// ✅ Custom providers
@Module({
  providers: [
    { provide: 'API_KEY', useValue: 'secret-key' },                       // useValue
    { provide: LoggerService, useClass: ProdLoggerService },               // useClass
    { provide: 'DB_CONNECTION', useFactory: (cfg: ConfigService) =>        // useFactory
        createConnection(cfg.get('DATABASE_URL')), inject: [ConfigService] },
  ],
})
export class AppModule {}

// ✅ Scopes: DEFAULT (singleton), REQUEST (per-request), TRANSIENT (per-injection)
@Injectable({ scope: Scope.REQUEST })
export class RequestScopedService {}

// ❌ NEVER: Instantiate manually
const service = new UsersService(); // breaks DI, no dependencies resolved
```

## DTOs & Validation (REQUIRED)

```typescript
// ✅ class-validator decorators on DTO classes
import { IsString, IsEmail, IsOptional, MinLength } from 'class-validator';

export class CreateUserDto {
  @IsString()
  @MinLength(2)
  name: string;

  @IsEmail()
  email: string;

  @IsOptional()
  @IsString()
  role?: string;
}

// ✅ Global ValidationPipe in main.ts
app.useGlobalPipes(new ValidationPipe({
  whitelist: true,              // strip unknown properties
  forbidNonWhitelisted: true,   // throw on unknown properties
  transform: true,              // auto-transform to DTO class instances
}));

// ✅ Zod alternative with custom pipe
import { ZodSchema } from 'zod';

@Injectable()
export class ZodValidationPipe implements PipeTransform {
  constructor(private schema: ZodSchema) {}
  transform(value: unknown) {
    return this.schema.parse(value);
  }
}

// Usage: @Body(new ZodValidationPipe(createUserSchema)) dto: CreateUserDto

// ❌ NEVER: Validate manually in controllers, accept raw `any` bodies
```

## Guards

```typescript
// ✅ Implement CanActivate, use ExecutionContext
@Injectable()
export class AuthGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean | Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    return !!request.headers.authorization;
  }
}

// ✅ Roles guard with SetMetadata + Reflector
export const ROLES_KEY = 'roles';
export const Roles = (...roles: string[]) => SetMetadata(ROLES_KEY, roles);

@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const roles = this.reflector.getAllAndOverride<string[]>(ROLES_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);
    if (!roles) return true;
    const { user } = context.switchToHttp().getRequest();
    return roles.some((role) => user.roles?.includes(role));
  }
}

// Apply per-route or globally
@UseGuards(AuthGuard, RolesGuard)
@Roles('admin')
@Post()
create(@Body() dto: CreateUserDto) {}

// Global guard via APP_GUARD
{ provide: APP_GUARD, useClass: AuthGuard }
```

## Interceptors

```typescript
// ✅ Response transformation interceptor
@Injectable()
export class TransformInterceptor<T> implements NestInterceptor<T, { data: T }> {
  intercept(context: ExecutionContext, next: CallHandler): Observable<{ data: T }> {
    return next.handle().pipe(map((data) => ({ data })));
  }
}

// ✅ Logging interceptor
@Injectable()
export class LoggingInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const now = Date.now();
    return next.handle().pipe(
      tap(() => console.log(`${context.getHandler().name} - ${Date.now() - now}ms`)),
    );
  }
}
```

## Exception Filters

```typescript
// ✅ Throw built-in exceptions — NestJS handles the response
throw new NotFoundException(`User #${id} not found`);
throw new BadRequestException('Invalid input');
throw new UnauthorizedException();
throw new ForbiddenException();

// ✅ Custom exception filter
@Catch(HttpException)
export class HttpExceptionFilter implements ExceptionFilter {
  catch(exception: HttpException, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse();
    const status = exception.getStatus();

    response.status(status).json({
      statusCode: status,
      message: exception.message,
      timestamp: new Date().toISOString(),
    });
  }
}

// Register globally via APP_FILTER or @UseFilters()
{ provide: APP_FILTER, useClass: HttpExceptionFilter }

// ❌ NEVER: try/catch in every controller method
```

## Pipes

```typescript
// ✅ Built-in pipes for parameter transformation
@Get(':id')
findOne(@Param('id', ParseIntPipe) id: number) {}

@Get(':uuid')
findByUuid(@Param('uuid', ParseUUIDPipe) uuid: string) {}

@Get()
findAll(@Query('active', new DefaultValuePipe(true), ParseBoolPipe) active: boolean) {}

// ✅ Custom pipe
@Injectable()
export class TrimPipe implements PipeTransform<string, string> {
  transform(value: string): string {
    return typeof value === 'string' ? value.trim() : value;
  }
}
```

## Custom Decorators

```typescript
// ✅ Parameter decorator — extract data from request
export const CurrentUser = createParamDecorator(
  (data: keyof User | undefined, ctx: ExecutionContext) => {
    const request = ctx.switchToHttp().getRequest();
    const user = request.user;
    return data ? user?.[data] : user;
  },
);

// Usage: @Get('me') getProfile(@CurrentUser() user: User) {}
// Usage: @Get('me') getName(@CurrentUser('name') name: string) {}

// ✅ Combine decorators with applyDecorators
export const Auth = (...roles: string[]) =>
  applyDecorators(
    UseGuards(AuthGuard, RolesGuard),
    Roles(...roles),
  );

// Usage: @Auth('admin') @Post() create() {}
```

## Configuration

```typescript
// ✅ ConfigModule with validation
@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: ['.env.local', '.env'],
      validate: (config) => envSchema.parse(config), // Zod validation
    }),
  ],
})
export class AppModule {}

// ✅ Typed config with registerAs
export const databaseConfig = registerAs('database', () => ({
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT, 10) || 5432,
}));

// Inject typed config
constructor(
  @Inject(databaseConfig.KEY)
  private dbConfig: ConfigType<typeof databaseConfig>,
) {}
```

## Keywords

nestjs, nest, nest.js, backend, api, rest, module, controller, service, provider, guard, interceptor, pipe, filter, dto, validation, dependency injection, decorator, middleware, configuration
