describe 'Ludwig grammar', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('language-ludwig')

    runs ->
      grammar = atom.grammars.grammarForScopeName('source.ludwig')

  it 'parses the grammar', ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe 'source.ludwig'

  it 'tokenizes requires', ->
    {tokens} = grammar.tokenizeLine('requires Ludwig.List')
    expect(tokens[0]).toEqual value: 'requires', scopes: ['source.ludwig', 'keyword.other.ludwig']
    expect(tokens[2]).toEqual value: 'Ludwig.List', scopes: ['source.ludwig', 'support.class.ludwig']

  it 'tokenizes requires as', ->
    {tokens} = grammar.tokenizeLine('requires Ludwig.List as List')
    expect(tokens[0]).toEqual value: 'requires', scopes: ['source.ludwig', 'keyword.other.ludwig']
    expect(tokens[2]).toEqual value: 'Ludwig.List', scopes: ['source.ludwig', 'support.class.ludwig']
    expect(tokens[4]).toEqual value: 'as', scopes: ['source.ludwig', 'keyword.other.ludwig']
    expect(tokens[6]).toEqual value: 'List', scopes: ['source.ludwig', 'support.class.ludwig']

  it 'tokenizes multi-line requires', ->
    tokens = grammar.tokenizeLines('requires Ludwig.List\n         Ludwig.Int\n         Ludwig.String as String')
    expect(tokens[0][0]).toEqual value: 'requires', scopes: ['source.ludwig', 'keyword.other.ludwig']
    expect(tokens[0][2]).toEqual value: 'Ludwig.List', scopes: ['source.ludwig', 'support.class.ludwig']
    expect(tokens[1][1]).toEqual value: 'Ludwig.Int', scopes: ['source.ludwig', 'support.class.ludwig']
    expect(tokens[2][1]).toEqual value: 'Ludwig.String', scopes: ['source.ludwig', 'support.class.ludwig']
    expect(tokens[2][3]).toEqual value: 'as', scopes: ['source.ludwig', 'keyword.other.ludwig']
    expect(tokens[2][5]).toEqual value: 'String', scopes: ['source.ludwig', 'support.class.ludwig']

  it 'tokenizes sum types', ->
    tokens = grammar.tokenizeLines('type ColorPreference:\n    | NoPreference\n    | SpecificPreference Color')
    expect(tokens[0][0]).toEqual value: 'type', scopes: ['source.ludwig', 'keyword.other.ludwig']
    expect(tokens[0][2]).toEqual value: 'ColorPreference', scopes: ['source.ludwig', 'support.class.ludwig']
    expect(tokens[1][1]).toEqual value: 'NoPreference', scopes: ['source.ludwig', 'support.class.ludwig']
    expect(tokens[2][1]).toEqual value: 'SpecificPreference', scopes: ['source.ludwig', 'support.class.ludwig']
    expect(tokens[2][3]).toEqual value: 'Color', scopes: ['source.ludwig', 'support.class.ludwig']

  it 'tokenizes bindings', ->
    {tokens} = grammar.tokenizeLine('x: 1')
    expect(tokens[0]).toEqual value: 'x', scopes: ['source.ludwig', 'variable.ludwig']

  it 'tokenizes exports', ->
    tokens = grammar.tokenizeLines('exports\n    type Foo\n    bar')
    expect(tokens[0][0]).toEqual value: 'exports', scopes: ['source.ludwig', 'keyword.other.ludwig']
    expect(tokens[1][1]).toEqual value: 'type', scopes: ['source.ludwig', 'keyword.other.ludwig']
    expect(tokens[1][3]).toEqual value: 'Foo', scopes: ['source.ludwig', 'support.class.ludwig']

  it 'tokenizes infixl operators', ->
    {tokens} = grammar.tokenizeLine('operator <> infixl 3: and')
    expect(tokens[0]).toEqual value: 'operator', scopes: ['source.ludwig', 'keyword.other.ludwig']
    expect(tokens[2]).toEqual value: 'infixl', scopes: ['source.ludwig', 'keyword.other.ludwig']

  it 'tokenizes infixr operators', ->
    {tokens} = grammar.tokenizeLine('operator <> infixr 3: and')
    expect(tokens[0]).toEqual value: 'operator', scopes: ['source.ludwig', 'keyword.other.ludwig']
    expect(tokens[2]).toEqual value: 'infixr', scopes: ['source.ludwig', 'keyword.other.ludwig']

  it 'tokenizes infixl operators', ->
    {tokens} = grammar.tokenizeLine('operator ! prefix: not')
    expect(tokens[0]).toEqual value: 'operator', scopes: ['source.ludwig', 'keyword.other.ludwig']
    expect(tokens[2]).toEqual value: 'prefix', scopes: ['source.ludwig', 'keyword.other.ludwig']
