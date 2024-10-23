local ls = require("luasnip") -- Carga LuaSnip
local s = ls.snippet -- Crea un snippet
local i = ls.insert_node -- Nodo de inserción
local t = ls.text_node -- Nodo de texto estático

-- Define el snippet para un test unitario en Angular
ls.add_snippets("typescript", {
  s("ngtest", {
    t({ "describe('" }),
    i(1, "NombreComponente"),
    t({ "', () => {", "  let component: " }),
    i(2, "NombreComponente"),
    t({ ";", "  let fixture: ComponentFixture<" }),
    i(3, "NombreComponente"),
    t({ ">;", "", "  beforeEach(async () => {", "    await TestBed.configureTestingModule({", "      declarations: [" }),
    i(4, "NombreComponente"),
    t({ "]", "    }).compileComponents();", "", "    fixture = TestBed.createComponent(" }),
    i(5, "NombreComponente"),
    t({
      ");",
      "    component = fixture.componentInstance;",
      "    fixture.detectChanges();",
      "  });",
      "",
      "  it('should create', () => {",
      "    expect(component).toBeTruthy();",
      "  });",
      "});",
    }),
    i(0), -- Nodo final donde quedará el cursor al completar el snippet
  }),
})

ls.add_snippets("typescript", {
  s("clg", {
    t({ "console.log('" }),
    i(1),
    t({ "');" }),
  }),
})

ls.add_snippets("typescript", {
  s("clo", {
    t({ "console.log(`" }),
    i(1),
    t({ ">> ${" }),
    i(2),
    t({ "}`);" }),
  }),
})
