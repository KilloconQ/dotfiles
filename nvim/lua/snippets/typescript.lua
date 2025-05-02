local ls = require("luasnip") -- Carga LuaSnip
local s = ls.snippet -- Crea un snippet
local i = ls.insert_node -- Nodo de inserción
local t = ls.text_node -- Nodo de texto estático
local rep = require("luasnip.extras").rep -- Repetición de nodos

-- Define el snippet para un test unitario en Angular
ls.add_snippets("typescript", {
  s("ngtest", {
    t({ "describe('" }),
    i(1, "NombreComponente"),
    t({ "', () => {", "  let component: " }),
    rep(1),
    t({ ";", "  let fixture: ComponentFixture<" }),
    rep(1),
    t({ ">;", "", "  beforeEach(async () => {", "    await TestBed.configureTestingModule({", "      imports: [" }),
    rep(1),
    t({ "]", "    }).compileComponents();", "", "    fixture = TestBed.createComponent(" }),
    rep(1),
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
    rep(1),
    t({ "}`);" }),
    i(0),
  }),
})

ls.filetype_extend("javascript", { "typescript" })
ls.filetype_extend("astro", { "typescript" })
ls.filetype_extend("typescriptreact", { "typescript" })
ls.filetype_extend("javascript", { "typescript" })
