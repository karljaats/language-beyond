describe 'Beyond grammar', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('language-beyond')

    runs ->
      grammar = atom.grammars.grammarForScopeName('source.beyond')

  it 'parses the grammar', ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe 'source.beyond'

  it 'tokenizes this with `.this` class', ->
    {tokens} = grammar.tokenizeLine 'this.x'

    expect(tokens[0]).toEqual value: 'this', scopes: ['source.beyond', 'variable.language.this.beyond']

  it 'tokenizes braces', ->
    {tokens} = grammar.tokenizeLine '(3 + 5) + a[b]'

    expect(tokens[0]).toEqual value: '(', scopes: ['source.beyond', 'punctuation.bracket.round.beyond']
    expect(tokens[6]).toEqual value: ')', scopes: ['source.beyond', 'punctuation.bracket.round.beyond']
    expect(tokens[10]).toEqual value: '[', scopes: ['source.beyond', 'punctuation.bracket.square.beyond']
    expect(tokens[12]).toEqual value: ']', scopes: ['source.beyond', 'punctuation.bracket.square.beyond']

    {tokens} = grammar.tokenizeLine 'a(b)'

    expect(tokens[1]).toEqual value: '(', scopes: ['source.beyond', 'meta.function-call.beyond', 'punctuation.definition.parameters.begin.bracket.round.beyond']
    expect(tokens[3]).toEqual value: ')', scopes: ['source.beyond', 'meta.function-call.beyond', 'punctuation.definition.parameters.end.bracket.round.beyond']

    lines = grammar.tokenizeLines '''
      class A<String>
      {
        public int[][] something(String[][] hello)
        {
        }
      }
    '''

    expect(lines[0][3]).toEqual value: '<', scopes: ['source.beyond', 'meta.class.beyond', 'punctuation.bracket.angle.beyond']
    expect(lines[0][5]).toEqual value: '>', scopes: ['source.beyond', 'meta.class.beyond', 'punctuation.bracket.angle.beyond']
    expect(lines[1][0]).toEqual value: '{', scopes: ['source.beyond', 'meta.class.beyond', 'punctuation.section.class.begin.bracket.curly.beyond']
    expect(lines[2][4]).toEqual value: '[', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.return-type.beyond', 'punctuation.bracket.square.beyond']
    expect(lines[2][5]).toEqual value: ']', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.return-type.beyond', 'punctuation.bracket.square.beyond']
    expect(lines[2][6]).toEqual value: '[', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.return-type.beyond', 'punctuation.bracket.square.beyond']
    expect(lines[2][7]).toEqual value: ']', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.return-type.beyond', 'punctuation.bracket.square.beyond']
    expect(lines[2][8]).toEqual value: ' ', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond']
    expect(lines[2][10]).toEqual value: '(', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'punctuation.definition.parameters.begin.bracket.round.beyond']
    expect(lines[2][12]).toEqual value: '[', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'punctuation.bracket.square.beyond']
    expect(lines[2][13]).toEqual value: ']', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'punctuation.bracket.square.beyond']
    expect(lines[2][14]).toEqual value: '[', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'punctuation.bracket.square.beyond']
    expect(lines[2][15]).toEqual value: ']', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'punctuation.bracket.square.beyond']
    expect(lines[2][18]).toEqual value: ')', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'punctuation.definition.parameters.end.bracket.round.beyond']
    expect(lines[3][1]).toEqual value: '{', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'punctuation.section.method.begin.bracket.curly.beyond']
    expect(lines[4][1]).toEqual value: '}', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'punctuation.section.method.end.bracket.curly.beyond']
    expect(lines[5][0]).toEqual value: '}', scopes: ['source.beyond', 'meta.class.beyond', 'punctuation.section.class.end.bracket.curly.beyond']

  it 'tokenizes punctuation', ->
    {tokens} = grammar.tokenizeLine 'int a, b, c;'

    expect(tokens[3]).toEqual value: ',', scopes: ['source.beyond', 'meta.definition.variable.beyond', 'punctuation.separator.delimiter.beyond']
    expect(tokens[6]).toEqual value: ',', scopes: ['source.beyond', 'meta.definition.variable.beyond', 'punctuation.separator.delimiter.beyond']
    expect(tokens[9]).toEqual value: ';', scopes: ['source.beyond', 'punctuation.terminator.beyond']

    {tokens} = grammar.tokenizeLine 'a.b(1, 2, c);'

    expect(tokens[1]).toEqual value: '.', scopes: ['source.beyond', 'meta.method-call.beyond', 'punctuation.separator.period.beyond']
    expect(tokens[5]).toEqual value: ',', scopes: ['source.beyond', 'meta.method-call.beyond', 'punctuation.separator.delimiter.beyond']
    expect(tokens[8]).toEqual value: ',', scopes: ['source.beyond', 'meta.method-call.beyond', 'punctuation.separator.delimiter.beyond']
    expect(tokens[11]).toEqual value: ';', scopes: ['source.beyond', 'punctuation.terminator.beyond']

    {tokens} = grammar.tokenizeLine 'a . b'

    expect(tokens[2]).toEqual value: '.', scopes: ['source.beyond', 'punctuation.separator.period.beyond']

  it 'tokenizes the `package` keyword', ->
    {tokens} = grammar.tokenizeLine 'package java.util.example;'

    expect(tokens[0]).toEqual value: 'package', scopes: ['source.beyond', 'meta.package.beyond', 'keyword.other.package.beyond']
    expect(tokens[1]).toEqual value: ' ', scopes: ['source.beyond', 'meta.package.beyond']
    expect(tokens[2]).toEqual value: 'java', scopes: ['source.beyond', 'meta.package.beyond', 'storage.modifier.package.beyond']
    expect(tokens[3]).toEqual value: '.', scopes: ['source.beyond', 'meta.package.beyond', 'storage.modifier.package.beyond', 'punctuation.separator.beyond']
    expect(tokens[4]).toEqual value: 'util', scopes: ['source.beyond', 'meta.package.beyond', 'storage.modifier.package.beyond']
    expect(tokens[7]).toEqual value: ';', scopes: ['source.beyond', 'meta.package.beyond', 'punctuation.terminator.beyond']

    {tokens} = grammar.tokenizeLine 'package java.Hi;'

    expect(tokens[4]).toEqual value: 'H', scopes: ['source.beyond', 'meta.package.beyond', 'storage.modifier.package.beyond', 'invalid.deprecated.package_name_not_lowercase.beyond']

    {tokens} = grammar.tokenizeLine 'package java.3a;'

    expect(tokens[4]).toEqual value: '3', scopes: ['source.beyond', 'meta.package.beyond', 'storage.modifier.package.beyond', 'invalid.illegal.character_not_allowed_here.beyond']

    {tokens} = grammar.tokenizeLine 'package java.-hi;'

    expect(tokens[4]).toEqual value: '-', scopes: ['source.beyond', 'meta.package.beyond', 'storage.modifier.package.beyond', 'invalid.illegal.character_not_allowed_here.beyond']

    {tokens} = grammar.tokenizeLine 'package java._;'

    expect(tokens[4]).toEqual value: '_', scopes: ['source.beyond', 'meta.package.beyond', 'storage.modifier.package.beyond', 'invalid.illegal.character_not_allowed_here.beyond']

    {tokens} = grammar.tokenizeLine 'package java.__;'

    expect(tokens[4]).toEqual value: '__', scopes: ['source.beyond', 'meta.package.beyond', 'storage.modifier.package.beyond']

    {tokens} = grammar.tokenizeLine 'package java.int;'

    expect(tokens[4]).toEqual value: 'int', scopes: ['source.beyond', 'meta.package.beyond', 'storage.modifier.package.beyond', 'invalid.illegal.character_not_allowed_here.beyond']

    {tokens} = grammar.tokenizeLine 'package java.interesting;'

    expect(tokens[4]).toEqual value: 'interesting', scopes: ['source.beyond', 'meta.package.beyond', 'storage.modifier.package.beyond']

    {tokens} = grammar.tokenizeLine 'package java..hi;'

    expect(tokens[4]).toEqual value: '.', scopes: ['source.beyond', 'meta.package.beyond', 'storage.modifier.package.beyond', 'invalid.illegal.character_not_allowed_here.beyond']

    {tokens} = grammar.tokenizeLine 'package java.;'

    expect(tokens[3]).toEqual value: '.', scopes: ['source.beyond', 'meta.package.beyond', 'storage.modifier.package.beyond', 'invalid.illegal.character_not_allowed_here.beyond']

  it 'tokenizes the `import` keyword', ->
    {tokens} = grammar.tokenizeLine 'import java.util.Example;'

    expect(tokens[0]).toEqual value: 'import', scopes: ['source.beyond', 'meta.import.beyond', 'keyword.other.import.beyond']
    expect(tokens[1]).toEqual value: ' ', scopes: ['source.beyond', 'meta.import.beyond']
    #expect(tokens[2]).toEqual value: 'java', scopes: ['source.beyond', 'meta.import.beyond', 'storage.modifier.import.beyond']
    #expect(tokens[3]).toEqual value: '.', scopes: ['source.beyond', 'meta.import.beyond', 'storage.modifier.import.beyond', 'punctuation.separator.beyond']
    #expect(tokens[4]).toEqual value: 'util', scopes: ['source.beyond', 'meta.import.beyond', 'storage.modifier.import.beyond']
    #expect(tokens[7]).toEqual value: ';', scopes: ['source.beyond', 'meta.import.beyond', 'punctuation.terminator.beyond']

    {tokens} = grammar.tokenizeLine 'import java.util.*;'

    #expect(tokens[6]).toEqual value: '*', scopes: ['source.beyond', 'meta.import.beyond', 'storage.modifier.import.beyond', 'variable.language.wildcard.beyond']

    {tokens} = grammar.tokenizeLine 'import static java.lang.Math.PI;'

    expect(tokens[2]).toEqual value: 'static', scopes: ['source.beyond', 'meta.import.beyond', 'storage.modifier.beyond']

    {tokens} = grammar.tokenizeLine 'import java.3a;'

    #expect(tokens[4]).toEqual value: '3', scopes: ['source.beyond', 'meta.import.beyond', 'storage.modifier.import.beyond', 'invalid.illegal.character_not_allowed_here.beyond']

    {tokens} = grammar.tokenizeLine 'import java.-hi;'

    #expect(tokens[4]).toEqual value: '-', scopes: ['source.beyond', 'meta.import.beyond', 'storage.modifier.import.beyond', 'invalid.illegal.character_not_allowed_here.beyond']

    {tokens} = grammar.tokenizeLine 'import java._;'

    #expect(tokens[4]).toEqual value: '_', scopes: ['source.beyond', 'meta.import.beyond', 'storage.modifier.import.beyond', 'invalid.illegal.character_not_allowed_here.beyond']

    {tokens} = grammar.tokenizeLine 'import java.__;'

    #expect(tokens[4]).toEqual value: '__', scopes: ['source.beyond', 'meta.import.beyond', 'storage.modifier.import.beyond']

    {tokens} = grammar.tokenizeLine 'import java.**;'

    #expect(tokens[5]).toEqual value: '*', scopes: ['source.beyond', 'meta.import.beyond', 'storage.modifier.import.beyond', 'invalid.illegal.character_not_allowed_here.beyond']

    {tokens} = grammar.tokenizeLine 'import java.a*;'

    #expect(tokens[5]).toEqual value: '*', scopes: ['source.beyond', 'meta.import.beyond', 'storage.modifier.import.beyond', 'invalid.illegal.character_not_allowed_here.beyond']

    {tokens} = grammar.tokenizeLine 'import java.int;'

    #expect(tokens[4]).toEqual value: 'int', scopes: ['source.beyond', 'meta.import.beyond', 'storage.modifier.import.beyond', 'invalid.illegal.character_not_allowed_here.beyond']

    {tokens} = grammar.tokenizeLine 'import java.interesting;'

    #expect(tokens[4]).toEqual value: 'interesting', scopes: ['source.beyond', 'meta.import.beyond', 'storage.modifier.import.beyond']

    {tokens} = grammar.tokenizeLine 'import java..hi;'

    #expect(tokens[4]).toEqual value: '.', scopes: ['source.beyond', 'meta.import.beyond', 'storage.modifier.import.beyond', 'invalid.illegal.character_not_allowed_here.beyond']

    {tokens} = grammar.tokenizeLine 'import java.;'

    #expect(tokens[3]).toEqual value: '.', scopes: ['source.beyond', 'meta.import.beyond', 'storage.modifier.import.beyond', 'invalid.illegal.character_not_allowed_here.beyond']

  it 'tokenizes module keywords', ->
    lines = grammar.tokenizeLines '''
      module Provider {
        requires ServiceInterface;
        provides javax0.serviceinterface.ServiceInterface with javax0.serviceprovider.Provider;
      }
    '''

    expect(lines[0][0]).toEqual value: 'module', scopes: ['source.beyond', 'meta.module.beyond', 'storage.modifier.beyond']
    expect(lines[0][2]).toEqual value: 'Provider', scopes: ['source.beyond', 'meta.module.beyond', 'entity.name.type.module.beyond']
    expect(lines[0][4]).toEqual value: '{', scopes: ['source.beyond', 'meta.module.beyond', 'punctuation.section.module.begin.bracket.curly.beyond']
    expect(lines[1][1]).toEqual value: 'requires', scopes: ['source.beyond', 'meta.module.beyond', 'meta.module.body.beyond', 'keyword.module.beyond']
    expect(lines[2][1]).toEqual value: 'provides', scopes: ['source.beyond', 'meta.module.beyond', 'meta.module.body.beyond', 'keyword.module.beyond']
    expect(lines[2][3]).toEqual value: 'with', scopes: ['source.beyond', 'meta.module.beyond', 'meta.module.body.beyond', 'keyword.module.beyond']
    expect(lines[3][0]).toEqual value: '}', scopes: ['source.beyond', 'meta.module.beyond', 'punctuation.section.module.end.bracket.curly.beyond']

  it 'tokenizes classes', ->
    lines = grammar.tokenizeLines '''
      class Thing {
        int x;
      }
    '''

    expect(lines[0][0]).toEqual value: 'class', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.identifier.beyond', 'storage.modifier.beyond']
    expect(lines[0][2]).toEqual value: 'Thing', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.identifier.beyond', 'entity.name.type.class.beyond']

  it 'tokenizes methods', ->
    lines = grammar.tokenizeLines '''
      class A
      {
        A(int a, int b)
        {
        }
      }
    '''

    expect(lines[2][1]).toEqual value: 'A', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'entity.name.function.beyond']
    expect(lines[2][2]).toEqual value: '(', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'punctuation.definition.parameters.begin.bracket.round.beyond']
    expect(lines[2][3]).toEqual value: 'int', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'storage.type.primitive.beyond']
    expect(lines[2][5]).toEqual value: 'a', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'variable.parameter.beyond']
    expect(lines[2][6]).toEqual value: ',', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'punctuation.separator.delimiter.beyond']
    expect(lines[2][11]).toEqual value: ')', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'punctuation.definition.parameters.end.bracket.round.beyond']
    expect(lines[3][1]).toEqual value: '{', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'punctuation.section.method.begin.bracket.curly.beyond']
    expect(lines[4][1]).toEqual value: '}', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'punctuation.section.method.end.bracket.curly.beyond']

  it 'tokenizes variable-length argument list (varargs)', ->
    lines = grammar.tokenizeLines '''
      class A
      {
        void func1(String... args)
        {
        }

        void func2(int /* ... */ arg, int ... args)
        {
        }
      }
    '''
    expect(lines[2][5]).toEqual value: 'String', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'storage.type.beyond']
    expect(lines[2][6]).toEqual value: '...', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'punctuation.definition.parameters.varargs.beyond']
    expect(lines[6][5]).toEqual value: 'int', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'storage.type.primitive.beyond']
    expect(lines[6][8]).toEqual value: ' ... ', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'comment.block.beyond']
    expect(lines[6][14]).toEqual value: 'int', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'storage.type.primitive.beyond']
    expect(lines[6][16]).toEqual value: '...', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'punctuation.definition.parameters.varargs.beyond']

  it 'tokenizes `final` in class method', ->
    lines = grammar.tokenizeLines '''
      class A
      {
        public int doSomething(final int finalScore, final int scorefinal)
        {
          return finalScore;
        }
      }
    '''

    expect(lines[2][7]).toEqual value: 'final', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'storage.modifier.beyond']
    expect(lines[2][11]).toEqual value: 'finalScore', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'variable.parameter.beyond']
    expect(lines[2][14]).toEqual value: 'final', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'storage.modifier.beyond']
    expect(lines[2][18]).toEqual value: 'scorefinal', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'variable.parameter.beyond']
    expect(lines[4][2]).toEqual value: ' finalScore', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond']

  describe 'numbers', ->
    describe 'integers', ->
      it 'tokenizes hexadecimal integers', ->
        {tokens} = grammar.tokenizeLine '0x0'
        expect(tokens[0]).toEqual value: '0x0', scopes: ['source.beyond', 'constant.numeric.hex.beyond']

        {tokens} = grammar.tokenizeLine '0X0'
        expect(tokens[0]).toEqual value: '0X0', scopes: ['source.beyond', 'constant.numeric.hex.beyond']

        {tokens} = grammar.tokenizeLine '0x1234567ABCDEF'
        expect(tokens[0]).toEqual value: '0x1234567ABCDEF', scopes: ['source.beyond', 'constant.numeric.hex.beyond']

        {tokens} = grammar.tokenizeLine '0x1234567aBcDEf'
        expect(tokens[0]).toEqual value: '0x1234567aBcDEf', scopes: ['source.beyond', 'constant.numeric.hex.beyond']

        {tokens} = grammar.tokenizeLine '0x3746A4l'
        expect(tokens[0]).toEqual value: '0x3746A4l', scopes: ['source.beyond', 'constant.numeric.hex.beyond']

        {tokens} = grammar.tokenizeLine '0xC3L'
        expect(tokens[0]).toEqual value: '0xC3L', scopes: ['source.beyond', 'constant.numeric.hex.beyond']

        {tokens} = grammar.tokenizeLine '0x0_1B'
        expect(tokens[0]).toEqual value: '0x0_1B', scopes: ['source.beyond', 'constant.numeric.hex.beyond']

        {tokens} = grammar.tokenizeLine '0xCF______3_2_A_73_B'
        expect(tokens[0]).toEqual value: '0xCF______3_2_A_73_B', scopes: ['source.beyond', 'constant.numeric.hex.beyond']

        {tokens} = grammar.tokenizeLine '0xCF______3_2_A_73_BL'
        expect(tokens[0]).toEqual value: '0xCF______3_2_A_73_BL', scopes: ['source.beyond', 'constant.numeric.hex.beyond']

        # Invalid
        {tokens} = grammar.tokenizeLine '0x_0'
        expect(tokens[0]).toEqual value: '0x_0', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '0x_'
        expect(tokens[0]).toEqual value: '0x_', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '0x0_'
        expect(tokens[0]).toEqual value: '0x0_', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '0x123ABCQ'
        expect(tokens[0]).toEqual value: '0x123ABCQ', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '0x123ABC$'
        expect(tokens[0]).toEqual value: '0x123ABC$', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '0x123ABC_L'
        expect(tokens[0]).toEqual value: '0x123ABC_L', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '0x123ABCLl'
        expect(tokens[0]).toEqual value: '0x123ABCLl', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine 'a0x123ABC'
        expect(tokens[0]).toEqual value: 'a0x123ABC', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '$0x123ABC'
        expect(tokens[0]).toEqual value: '$0x123ABC', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '1x0'
        expect(tokens[0]).toEqual value: '1x0', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '.0x1'
        expect(tokens[0]).toEqual value: '.', scopes: ['source.beyond', 'punctuation.separator.period.beyond']

      it 'tokenizes binary literals', ->
        {tokens} = grammar.tokenizeLine '0b0'
        expect(tokens[0]).toEqual value: '0b0', scopes: ['source.beyond', 'constant.numeric.binary.beyond']

        {tokens} = grammar.tokenizeLine '0B0'
        expect(tokens[0]).toEqual value: '0B0', scopes: ['source.beyond', 'constant.numeric.binary.beyond']

        {tokens} = grammar.tokenizeLine '0b10101010010101'
        expect(tokens[0]).toEqual value: '0b10101010010101', scopes: ['source.beyond', 'constant.numeric.binary.beyond']

        {tokens} = grammar.tokenizeLine '0b10_101__010______01_0_101'
        expect(tokens[0]).toEqual value: '0b10_101__010______01_0_101', scopes: ['source.beyond', 'constant.numeric.binary.beyond']

        {tokens} = grammar.tokenizeLine '0b1111l'
        expect(tokens[0]).toEqual value: '0b1111l', scopes: ['source.beyond', 'constant.numeric.binary.beyond']

        {tokens} = grammar.tokenizeLine '0b1111L'
        expect(tokens[0]).toEqual value: '0b1111L', scopes: ['source.beyond', 'constant.numeric.binary.beyond']

        {tokens} = grammar.tokenizeLine '0b11__01l'
        expect(tokens[0]).toEqual value: '0b11__01l', scopes: ['source.beyond', 'constant.numeric.binary.beyond']

        # Invalid
        {tokens} = grammar.tokenizeLine '0b_0'
        expect(tokens[0]).toEqual value: '0b_0', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '0b_'
        expect(tokens[0]).toEqual value: '0b_', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '0b0_'
        expect(tokens[0]).toEqual value: '0b0_', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '0b1001010102'
        expect(tokens[0]).toEqual value: '0b1001010102', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '0b100101010Q'
        expect(tokens[0]).toEqual value: '0b100101010Q', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '0b100101010$'
        expect(tokens[0]).toEqual value: '0b100101010$', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine 'a0b100101010'
        expect(tokens[0]).toEqual value: 'a0b100101010', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '$0b100101010'
        expect(tokens[0]).toEqual value: '$0b100101010', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '0b100101010Ll'
        expect(tokens[0]).toEqual value: '0b100101010Ll', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '0b100101010_L'
        expect(tokens[0]).toEqual value: '0b100101010_L', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '1b0'
        expect(tokens[0]).toEqual value: '1b0', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '.0b100101010'
        expect(tokens[0]).toEqual value: '.', scopes: ['source.beyond', 'punctuation.separator.period.beyond']

      it 'tokenizes octal literals', ->
        {tokens} = grammar.tokenizeLine '00'
        expect(tokens[0]).toEqual value: '00', scopes: ['source.beyond', 'constant.numeric.octal.beyond']

        {tokens} = grammar.tokenizeLine '01234567'
        expect(tokens[0]).toEqual value: '01234567', scopes: ['source.beyond', 'constant.numeric.octal.beyond']

        {tokens} = grammar.tokenizeLine '07263_3251___3625_1_4'
        expect(tokens[0]).toEqual value: '07263_3251___3625_1_4', scopes: ['source.beyond', 'constant.numeric.octal.beyond']

        {tokens} = grammar.tokenizeLine '07263l'
        expect(tokens[0]).toEqual value: '07263l', scopes: ['source.beyond', 'constant.numeric.octal.beyond']

        {tokens} = grammar.tokenizeLine '07263L'
        expect(tokens[0]).toEqual value: '07263L', scopes: ['source.beyond', 'constant.numeric.octal.beyond']

        {tokens} = grammar.tokenizeLine '011__24l'
        expect(tokens[0]).toEqual value: '011__24l', scopes: ['source.beyond', 'constant.numeric.octal.beyond']

        # Invalid
        {tokens} = grammar.tokenizeLine '0'
        expect(tokens[0]).toEqual value: '0', scopes: ['source.beyond', 'constant.numeric.decimal.beyond']

        {tokens} = grammar.tokenizeLine '0_'
        expect(tokens[0]).toEqual value: '0_', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '0_0'
        expect(tokens[0]).toEqual value: '0_0', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '01_'
        expect(tokens[0]).toEqual value: '01_', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '02637242638'
        expect(tokens[0]).toEqual value: '02637242638', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '0263724263Q'
        expect(tokens[0]).toEqual value: '0263724263Q', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '0263724263$'
        expect(tokens[0]).toEqual value: '0263724263$', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine 'a0263724263'
        expect(tokens[0]).toEqual value: 'a0263724263', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '$0263724263'
        expect(tokens[0]).toEqual value: '$0263724263', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '0263724263Ll'
        expect(tokens[0]).toEqual value: '0263724263Ll', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '0263724263_L'
        expect(tokens[0]).toEqual value: '0263724263_L', scopes: ['source.beyond']

      it 'tokenizes numeric integers', ->
        {tokens} = grammar.tokenizeLine '0'
        expect(tokens[0]).toEqual value: '0', scopes: ['source.beyond', 'constant.numeric.decimal.beyond']

        {tokens} = grammar.tokenizeLine '123456789'
        expect(tokens[0]).toEqual value: '123456789', scopes: ['source.beyond', 'constant.numeric.decimal.beyond']

        {tokens} = grammar.tokenizeLine '362__2643_0_7'
        expect(tokens[0]).toEqual value: '362__2643_0_7', scopes: ['source.beyond', 'constant.numeric.decimal.beyond']

        {tokens} = grammar.tokenizeLine '29473923603492738L'
        expect(tokens[0]).toEqual value: '29473923603492738L', scopes: ['source.beyond', 'constant.numeric.decimal.beyond']

        {tokens} = grammar.tokenizeLine '29473923603492738l'
        expect(tokens[0]).toEqual value: '29473923603492738l', scopes: ['source.beyond', 'constant.numeric.decimal.beyond']

        {tokens} = grammar.tokenizeLine '2947_39___23__60_3_4______92738l'
        expect(tokens[0]).toEqual value: '2947_39___23__60_3_4______92738l', scopes: ['source.beyond', 'constant.numeric.decimal.beyond']

        # Invalid
        {tokens} = grammar.tokenizeLine '01'
        expect(tokens[0]).toEqual value: '01', scopes: ['source.beyond', 'constant.numeric.octal.beyond']

        {tokens} = grammar.tokenizeLine '1_'
        expect(tokens[0]).toEqual value: '1_', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '_1'
        expect(tokens[0]).toEqual value: '_1', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '2639724263Q'
        expect(tokens[0]).toEqual value: '2639724263Q', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '2639724263$'
        expect(tokens[0]).toEqual value: '2639724263$', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine 'a2639724263'
        expect(tokens[0]).toEqual value: 'a2639724263', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '$2639724263'
        expect(tokens[0]).toEqual value: '$2639724263', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '2639724263Ll'
        expect(tokens[0]).toEqual value: '2639724263Ll', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '2639724263_L'
        expect(tokens[0]).toEqual value: '2639724263_L', scopes: ['source.beyond']

    describe 'floats', ->
      it 'tokenizes hexadecimal floats', ->
        {tokens} = grammar.tokenizeLine '0x0P0'
        expect(tokens[0]).toEqual value: '0x0P0', scopes: ['source.beyond', 'constant.numeric.hex.beyond']

        {tokens} = grammar.tokenizeLine '0x0p0'
        expect(tokens[0]).toEqual value: '0x0p0', scopes: ['source.beyond', 'constant.numeric.hex.beyond']

        {tokens} = grammar.tokenizeLine '0xDp3746'
        expect(tokens[0]).toEqual value: '0xDp3746', scopes: ['source.beyond', 'constant.numeric.hex.beyond']

        {tokens} = grammar.tokenizeLine '0xD__3p3_7_46'
        expect(tokens[0]).toEqual value: '0xD__3p3_7_46', scopes: ['source.beyond', 'constant.numeric.hex.beyond']

        {tokens} = grammar.tokenizeLine '0xD3.p3_7_46'
        expect(tokens[0]).toEqual value: '0xD3.p3_7_46', scopes: ['source.beyond', 'constant.numeric.hex.beyond']

        {tokens} = grammar.tokenizeLine '0xD3.17Fp3_7_46'
        expect(tokens[0]).toEqual value: '0xD3.17Fp3_7_46', scopes: ['source.beyond', 'constant.numeric.hex.beyond']

        {tokens} = grammar.tokenizeLine '0xD3.17_Fp3_7_46'
        expect(tokens[0]).toEqual value: '0xD3.17_Fp3_7_46', scopes: ['source.beyond', 'constant.numeric.hex.beyond']

        {tokens} = grammar.tokenizeLine '0xD3.17_Fp+3_7_46'
        expect(tokens[0]).toEqual value: '0xD3.17_Fp+3_7_46', scopes: ['source.beyond', 'constant.numeric.hex.beyond']

        {tokens} = grammar.tokenizeLine '0xD3.17_Fp-3_7_46'
        expect(tokens[0]).toEqual value: '0xD3.17_Fp-3_7_46', scopes: ['source.beyond', 'constant.numeric.hex.beyond']

        {tokens} = grammar.tokenizeLine '0xD3.17_Fp3_7_46F'
        expect(tokens[0]).toEqual value: '0xD3.17_Fp3_7_46F', scopes: ['source.beyond', 'constant.numeric.hex.beyond']

        {tokens} = grammar.tokenizeLine '0xD3.17_Fp3_7_46f'
        expect(tokens[0]).toEqual value: '0xD3.17_Fp3_7_46f', scopes: ['source.beyond', 'constant.numeric.hex.beyond']

        {tokens} = grammar.tokenizeLine '0xD3.17_Fp3_7_46D'
        expect(tokens[0]).toEqual value: '0xD3.17_Fp3_7_46D', scopes: ['source.beyond', 'constant.numeric.hex.beyond']

        {tokens} = grammar.tokenizeLine '0xD3.17_Fp3_7_46d'
        expect(tokens[0]).toEqual value: '0xD3.17_Fp3_7_46d', scopes: ['source.beyond', 'constant.numeric.hex.beyond']

        {tokens} = grammar.tokenizeLine '0xD3.17_Fp-3_7_46f'
        expect(tokens[0]).toEqual value: '0xD3.17_Fp-3_7_46f', scopes: ['source.beyond', 'constant.numeric.hex.beyond']

        {tokens} = grammar.tokenizeLine '0xD3.17_Fp-0f'
        expect(tokens[0]).toEqual value: '0xD3.17_Fp-0f', scopes: ['source.beyond', 'constant.numeric.hex.beyond']

        # Invalid
        {tokens} = grammar.tokenizeLine '0x0p'
        expect(tokens[0]).toEqual value: '0x0p', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '0x0pA'
        expect(tokens[0]).toEqual value: '0x0pA', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '0x0p+'
        expect(tokens[0]).toEqual value: '0x0p', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '0x0p'
        expect(tokens[0]).toEqual value: '0x0p', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '0x0pF'
        expect(tokens[0]).toEqual value: '0x0pF', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '0x0p_'
        expect(tokens[0]).toEqual value: '0x0p_', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '0x0_p1'
        expect(tokens[0]).toEqual value: '0x0_p1', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '0x0p1_'
        expect(tokens[0]).toEqual value: '0x0p1_', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '0x0p+-2'
        expect(tokens[0]).toEqual value: '0x0p', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '0x0p+2Ff'
        expect(tokens[0]).toEqual value: '0x0p', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '0x0._p2'
        expect(tokens[0]).toEqual value: '0x0', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '0x0_.p2'
        expect(tokens[0]).toEqual value: '0x0_', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '0x0..p2'
        expect(tokens[0]).toEqual value: '0x0', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '0x0Pp2'
        expect(tokens[0]).toEqual value: '0x0Pp2', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '0xp2'
        expect(tokens[0]).toEqual value: '0xp2', scopes: ['source.beyond']

      it 'tokenizes numeric floats', ->
        {tokens} = grammar.tokenizeLine '1.'
        expect(tokens[0]).toEqual value: '1.', scopes: ['source.beyond', 'constant.numeric.decimal.beyond']

        {tokens} = grammar.tokenizeLine '1.0'
        expect(tokens[0]).toEqual value: '1.0', scopes: ['source.beyond', 'constant.numeric.decimal.beyond']

        {tokens} = grammar.tokenizeLine '1273.47363'
        expect(tokens[0]).toEqual value: '1273.47363', scopes: ['source.beyond', 'constant.numeric.decimal.beyond']

        {tokens} = grammar.tokenizeLine '1_2.4_7__89_5'
        expect(tokens[0]).toEqual value: '1_2.4_7__89_5', scopes: ['source.beyond', 'constant.numeric.decimal.beyond']

        {tokens} = grammar.tokenizeLine '1.F'
        expect(tokens[0]).toEqual value: '1.F', scopes: ['source.beyond', 'constant.numeric.decimal.beyond']

        {tokens} = grammar.tokenizeLine '1.f'
        expect(tokens[0]).toEqual value: '1.f', scopes: ['source.beyond', 'constant.numeric.decimal.beyond']

        {tokens} = grammar.tokenizeLine '1.D'
        expect(tokens[0]).toEqual value: '1.D', scopes: ['source.beyond', 'constant.numeric.decimal.beyond']

        {tokens} = grammar.tokenizeLine '1.d'
        expect(tokens[0]).toEqual value: '1.d', scopes: ['source.beyond', 'constant.numeric.decimal.beyond']

        {tokens} = grammar.tokenizeLine '1.0f'
        expect(tokens[0]).toEqual value: '1.0f', scopes: ['source.beyond', 'constant.numeric.decimal.beyond']

        {tokens} = grammar.tokenizeLine '1.0_7f'
        expect(tokens[0]).toEqual value: '1.0_7f', scopes: ['source.beyond', 'constant.numeric.decimal.beyond']

        {tokens} = grammar.tokenizeLine '1.E5'
        expect(tokens[0]).toEqual value: '1.E5', scopes: ['source.beyond', 'constant.numeric.decimal.beyond']

        {tokens} = grammar.tokenizeLine '1.e5'
        expect(tokens[0]).toEqual value: '1.e5', scopes: ['source.beyond', 'constant.numeric.decimal.beyond']

        {tokens} = grammar.tokenizeLine '1.e5_7'
        expect(tokens[0]).toEqual value: '1.e5_7', scopes: ['source.beyond', 'constant.numeric.decimal.beyond']

        {tokens} = grammar.tokenizeLine '1.6e58_26'
        expect(tokens[0]).toEqual value: '1.6e58_26', scopes: ['source.beyond', 'constant.numeric.decimal.beyond']

        {tokens} = grammar.tokenizeLine '1.6e8f'
        expect(tokens[0]).toEqual value: '1.6e8f', scopes: ['source.beyond', 'constant.numeric.decimal.beyond']

        {tokens} = grammar.tokenizeLine '1.78e+7'
        expect(tokens[0]).toEqual value: '1.78e+7', scopes: ['source.beyond', 'constant.numeric.decimal.beyond']

        {tokens} = grammar.tokenizeLine '1.78e-7'
        expect(tokens[0]).toEqual value: '1.78e-7', scopes: ['source.beyond', 'constant.numeric.decimal.beyond']

        {tokens} = grammar.tokenizeLine '1.78e+7f'
        expect(tokens[0]).toEqual value: '1.78e+7f', scopes: ['source.beyond', 'constant.numeric.decimal.beyond']

        {tokens} = grammar.tokenizeLine '.7'
        expect(tokens[0]).toEqual value: '.7', scopes: ['source.beyond', 'constant.numeric.decimal.beyond']

        {tokens} = grammar.tokenizeLine '.726'
        expect(tokens[0]).toEqual value: '.726', scopes: ['source.beyond', 'constant.numeric.decimal.beyond']

        {tokens} = grammar.tokenizeLine '.72__6e97_5632f'
        expect(tokens[0]).toEqual value: '.72__6e97_5632f', scopes: ['source.beyond', 'constant.numeric.decimal.beyond']

        {tokens} = grammar.tokenizeLine '7_26e+52_3'
        expect(tokens[0]).toEqual value: '7_26e+52_3', scopes: ['source.beyond', 'constant.numeric.decimal.beyond']

        {tokens} = grammar.tokenizeLine '7_26e+52_3f'
        expect(tokens[0]).toEqual value: '7_26e+52_3f', scopes: ['source.beyond', 'constant.numeric.decimal.beyond']

        {tokens} = grammar.tokenizeLine '3f'
        expect(tokens[0]).toEqual value: '3f', scopes: ['source.beyond', 'constant.numeric.decimal.beyond']

        {tokens} = grammar.tokenizeLine '7_26f'
        expect(tokens[0]).toEqual value: '7_26f', scopes: ['source.beyond', 'constant.numeric.decimal.beyond']

        # Invalid
        {tokens} = grammar.tokenizeLine '1e'
        expect(tokens[0]).toEqual value: '1e', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '1.e'
        expect(tokens[0]).toEqual value: '1', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '.e'
        expect(tokens[0]).toEqual value: '.', scopes: ['source.beyond', 'punctuation.separator.period.beyond']

        {tokens} = grammar.tokenizeLine '1_.'
        expect(tokens[0]).toEqual value: '1_', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '1._'
        expect(tokens[0]).toEqual value: '1', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '_.'
        expect(tokens[0]).toEqual value: '_', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '1._1'
        expect(tokens[0]).toEqual value: '1', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '_1.1'
        expect(tokens[0]).toEqual value: '_1', scopes: ['source.beyond', 'variable.other.object.beyond']

        {tokens} = grammar.tokenizeLine '1.1_'
        expect(tokens[0]).toEqual value: '1', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '1e++7'
        expect(tokens[0]).toEqual value: '1e', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '1.ee5'
        expect(tokens[0]).toEqual value: '1', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '1.Ff'
        expect(tokens[0]).toEqual value: '1', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '1.e'
        expect(tokens[0]).toEqual value: '1', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '1..1'
        expect(tokens[0]).toEqual value: '1', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine 'a1'
        expect(tokens[0]).toEqual value: 'a1', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '1a'
        expect(tokens[0]).toEqual value: '1a', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '1.q'
        expect(tokens[0]).toEqual value: '1', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '1.3fa'
        expect(tokens[0]).toEqual value: '1', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '1.1_f'
        expect(tokens[0]).toEqual value: '1', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '1.1_e3'
        expect(tokens[0]).toEqual value: '1', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '$1'
        expect(tokens[0]).toEqual value: '$1', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '1$'
        expect(tokens[0]).toEqual value: '1$', scopes: ['source.beyond']

        {tokens} = grammar.tokenizeLine '$.1'
        expect(tokens[0]).toEqual value: '$', scopes: ['source.beyond', 'variable.other.object.beyond']

        {tokens} = grammar.tokenizeLine '.1$'
        expect(tokens[0]).toEqual value: '.', scopes: ['source.beyond', 'punctuation.separator.period.beyond']

  it 'tokenizes `final` in class fields', ->
    lines = grammar.tokenizeLines '''
      class A
      {
        private final int finala = 0;
        final private int bfinal = 1;
      }
    '''

    expect(lines[2][3]).toEqual value: 'final', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'storage.modifier.beyond']
    expect(lines[2][7]).toEqual value: 'finala', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'variable.other.definition.beyond']
    expect(lines[3][1]).toEqual value: 'final', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'storage.modifier.beyond']
    expect(lines[3][7]).toEqual value: 'bfinal', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'variable.other.definition.beyond']

  it 'tokenizes method-local variables', ->
    lines = grammar.tokenizeLines '''
      class A
      {
        public void fn()
        {
          String someString;
          String assigned = "Rand al'Thor";
          int primitive = 5;
        }
      }
    '''

    expect(lines[4][1]).toEqual value: 'String', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'meta.definition.variable.beyond', 'storage.type.beyond']
    expect(lines[4][3]).toEqual value: 'someString', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'meta.definition.variable.beyond', 'variable.other.definition.beyond']

    expect(lines[5][1]).toEqual value: 'String', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'meta.definition.variable.beyond', 'storage.type.beyond']
    expect(lines[5][3]).toEqual value: 'assigned', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'meta.definition.variable.beyond', 'variable.other.definition.beyond']
    expect(lines[5][5]).toEqual value: '=', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'keyword.operator.assignment.beyond']
    expect(lines[5][8]).toEqual value: "Rand al'Thor", scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'string.quoted.double.beyond']

    expect(lines[6][1]).toEqual value: 'int', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'meta.definition.variable.beyond', 'storage.type.primitive.beyond']
    expect(lines[6][3]).toEqual value: 'primitive', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'meta.definition.variable.beyond', 'variable.other.definition.beyond']
    expect(lines[6][5]).toEqual value: '=', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'keyword.operator.assignment.beyond']
    expect(lines[6][7]).toEqual value: '5', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'constant.numeric.decimal.beyond']

  it 'tokenizes variables defined with incorrect primitive types', ->
    lines = grammar.tokenizeLines '''
      class A {
        aint a = 1; int b = 2;
        aboolean c = true; boolean d = false;
      }
    '''

    expect(lines[1][0]).toEqual value: '  aint a ', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond']
    expect(lines[1][6]).toEqual value: 'int', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.primitive.beyond']
    expect(lines[1][8]).toEqual value: 'b', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'variable.other.definition.beyond']
    expect(lines[2][0]).toEqual value: '  aboolean c ', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond']
    expect(lines[2][6]).toEqual value: 'boolean', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.primitive.beyond']
    expect(lines[2][8]).toEqual value: 'd', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'variable.other.definition.beyond']

  it 'tokenizes capitalized variables', ->
    lines = grammar.tokenizeLines '''
      void func()
      {
        int g = 1;
        g += 2;
        int G = 1;
        G += 2;

        if (G > g) {
          // do something
        }
      }
    '''

    expect(lines[2][3]).toEqual value: 'g', scopes: ['source.beyond', 'meta.definition.variable.beyond', 'variable.other.definition.beyond']
    expect(lines[3][0]).toEqual value: '  g ', scopes: ['source.beyond']
    expect(lines[4][3]).toEqual value: 'G', scopes: ['source.beyond', 'meta.definition.variable.beyond', 'variable.other.definition.beyond']
    expect(lines[5][0]).toEqual value: '  G ', scopes: ['source.beyond'] # should not be highlighted as storage type!

    expect(lines[7][4]).toEqual value: 'G ', scopes: ['source.beyond'] # should not be highlighted as storage type!
    expect(lines[7][5]).toEqual value: '>', scopes: ['source.beyond', 'keyword.operator.comparison.beyond']
    expect(lines[7][6]).toEqual value: ' g', scopes: ['source.beyond']

  it 'tokenizes function and method calls', ->
    lines = grammar.tokenizeLines '''
      class A
      {
        A()
        {
          hello();
          hello(a, 1, "hello");
          $hello();
          this.hello();
          this . hello(a, b);
        }
      }
    '''

    expect(lines[4][1]).toEqual value: 'hello', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'meta.function-call.beyond', 'entity.name.function.beyond']
    expect(lines[4][2]).toEqual value: '(', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'meta.function-call.beyond', 'punctuation.definition.parameters.begin.bracket.round.beyond']
    expect(lines[4][3]).toEqual value: ')', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'meta.function-call.beyond', 'punctuation.definition.parameters.end.bracket.round.beyond']
    expect(lines[4][4]).toEqual value: ';', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'punctuation.terminator.beyond']

    expect(lines[5][1]).toEqual value: 'hello', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'meta.function-call.beyond', 'entity.name.function.beyond']
    expect(lines[5][3]).toEqual value: 'a', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'meta.function-call.beyond']
    expect(lines[5][4]).toEqual value: ',', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'meta.function-call.beyond', 'punctuation.separator.delimiter.beyond']
    expect(lines[5][6]).toEqual value: '1', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'meta.function-call.beyond', 'constant.numeric.decimal.beyond']
    expect(lines[5][9]).toEqual value: '"', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'meta.function-call.beyond', 'string.quoted.double.beyond', 'punctuation.definition.string.begin.beyond']
    expect(lines[5][11]).toEqual value: '"', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'meta.function-call.beyond', 'string.quoted.double.beyond', 'punctuation.definition.string.end.beyond']
    expect(lines[5][13]).toEqual value: ';', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'punctuation.terminator.beyond']

    expect(lines[6][1]).toEqual value: '$hello', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'meta.function-call.beyond', 'entity.name.function.beyond']

    expect(lines[7][1]).toEqual value: 'this', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'variable.language.this.beyond']
    expect(lines[7][2]).toEqual value: '.', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'meta.method-call.beyond', 'punctuation.separator.period.beyond']
    expect(lines[7][3]).toEqual value: 'hello', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'meta.method-call.beyond', 'entity.name.function.beyond']
    expect(lines[7][4]).toEqual value: '(', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'meta.method-call.beyond', 'punctuation.definition.parameters.begin.bracket.round.beyond']
    expect(lines[7][5]).toEqual value: ')', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'meta.method-call.beyond', 'punctuation.definition.parameters.end.bracket.round.beyond']
    expect(lines[7][6]).toEqual value: ';', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'punctuation.terminator.beyond']

    expect(lines[8][3]).toEqual value: '.', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'meta.method-call.beyond', 'punctuation.separator.period.beyond']
    expect(lines[8][4]).toEqual value: ' ', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'meta.method-call.beyond']
    expect(lines[8][5]).toEqual value: 'hello', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'meta.method-call.beyond', 'entity.name.function.beyond']
    expect(lines[8][7]).toEqual value: 'a', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'meta.method-call.beyond']
    expect(lines[8][8]).toEqual value: ',', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'meta.method-call.beyond', 'punctuation.separator.delimiter.beyond']
    expect(lines[8][11]).toEqual value: ';', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'punctuation.terminator.beyond']

  it 'tokenizes objects and properties', ->
    lines = grammar.tokenizeLines '''
      class A
      {
        A()
        {
          object.property;
          object.Property;
          Object.property;
          object . property;
          $object.$property;
          object.property1.property2;
          object.method().property;
          object.property.method();
          object.123illegal;
        }
      }
    '''

    expect(lines[4][1]).toEqual value: 'object', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'variable.other.object.beyond']
    expect(lines[4][2]).toEqual value: '.', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'punctuation.separator.period.beyond']
    expect(lines[4][3]).toEqual value: 'property', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'variable.other.property.beyond']
    expect(lines[4][4]).toEqual value: ';', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'punctuation.terminator.beyond']

    expect(lines[5][1]).toEqual value: 'object', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'variable.other.object.beyond']
    expect(lines[5][3]).toEqual value: 'Property', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'variable.other.property.beyond']

    expect(lines[6][1]).toEqual value: 'Object', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'variable.other.object.beyond']

    expect(lines[7][1]).toEqual value: 'object', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'variable.other.object.beyond']
    expect(lines[7][5]).toEqual value: 'property', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'variable.other.property.beyond']

    expect(lines[8][1]).toEqual value: '$object', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'variable.other.object.beyond']
    expect(lines[8][3]).toEqual value: '$property', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'variable.other.property.beyond']

    expect(lines[9][3]).toEqual value: 'property1', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'variable.other.object.property.beyond']
    expect(lines[9][5]).toEqual value: 'property2', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'variable.other.property.beyond']

    expect(lines[10][1]).toEqual value: 'object', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'variable.other.object.beyond']
    expect(lines[10][3]).toEqual value: 'method', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'meta.method-call.beyond', 'entity.name.function.beyond']
    expect(lines[10][7]).toEqual value: 'property', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'variable.other.property.beyond']

    expect(lines[11][3]).toEqual value: 'property', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'variable.other.object.property.beyond']
    expect(lines[11][5]).toEqual value: 'method', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'meta.method-call.beyond', 'entity.name.function.beyond']

    expect(lines[12][1]).toEqual value: 'object', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'variable.other.object.beyond']
    expect(lines[12][2]).toEqual value: '.', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'punctuation.separator.period.beyond']
    expect(lines[12][3]).toEqual value: '123illegal', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'invalid.illegal.identifier.beyond']
    expect(lines[12][4]).toEqual value: ';', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'punctuation.terminator.beyond']

  it 'tokenizes generics', ->
    lines = grammar.tokenizeLines '''
      class A<T extends A & B, String, Integer>
      {
        HashMap<Integer, String> map = new HashMap<>();
        CodeMap<String, ? extends ArrayList> codemap;
        C(Map<?, ? extends List<?>> m) {}
        Map<Integer, String> method() {}
        private Object otherMethod() { return null; }
        Set<Map.Entry<K, V>> set1;
        Set<java.util.List<K>> set2;
      }
    '''

    expect(lines[0][3]).toEqual value: '<', scopes: ['source.beyond', 'meta.class.beyond', 'punctuation.bracket.angle.beyond']
    expect(lines[0][4]).toEqual value: 'T', scopes: ['source.beyond', 'meta.class.beyond', 'storage.type.generic.beyond']
    expect(lines[0][5]).toEqual value: ' ', scopes: ['source.beyond', 'meta.class.beyond']
    expect(lines[0][6]).toEqual value: 'extends', scopes: ['source.beyond', 'meta.class.beyond', 'storage.modifier.extends.beyond']
    expect(lines[0][7]).toEqual value: ' ', scopes: ['source.beyond', 'meta.class.beyond']
    expect(lines[0][8]).toEqual value: 'A', scopes: ['source.beyond', 'meta.class.beyond', 'storage.type.generic.beyond']
    expect(lines[0][9]).toEqual value: ' ', scopes: ['source.beyond', 'meta.class.beyond']
    expect(lines[0][10]).toEqual value: '&', scopes: ['source.beyond', 'meta.class.beyond', 'punctuation.separator.types.beyond']
    expect(lines[0][11]).toEqual value: ' ', scopes: ['source.beyond', 'meta.class.beyond']
    expect(lines[0][12]).toEqual value: 'B', scopes: ['source.beyond', 'meta.class.beyond', 'storage.type.generic.beyond']
    expect(lines[0][13]).toEqual value: ',', scopes: ['source.beyond', 'meta.class.beyond', 'punctuation.separator.delimiter.beyond']
    expect(lines[0][14]).toEqual value: ' ', scopes: ['source.beyond', 'meta.class.beyond']
    expect(lines[0][15]).toEqual value: 'String', scopes: ['source.beyond', 'meta.class.beyond', 'storage.type.generic.beyond']
    expect(lines[0][16]).toEqual value: ',', scopes: ['source.beyond', 'meta.class.beyond', 'punctuation.separator.delimiter.beyond']
    expect(lines[0][17]).toEqual value: ' ', scopes: ['source.beyond', 'meta.class.beyond']
    expect(lines[0][18]).toEqual value: 'Integer', scopes: ['source.beyond', 'meta.class.beyond', 'storage.type.generic.beyond']
    expect(lines[0][19]).toEqual value: '>', scopes: ['source.beyond', 'meta.class.beyond', 'punctuation.bracket.angle.beyond']
    expect(lines[2][1]).toEqual value: 'HashMap', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.beyond']
    expect(lines[2][2]).toEqual value: '<', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.angle.beyond']
    expect(lines[2][3]).toEqual value: 'Integer', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.generic.beyond']
    expect(lines[2][4]).toEqual value: ',', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.separator.delimiter.beyond']
    expect(lines[2][6]).toEqual value: 'String', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.generic.beyond']
    expect(lines[2][7]).toEqual value: '>', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.angle.beyond']
    expect(lines[2][9]).toEqual value: 'map', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'variable.other.definition.beyond']
    expect(lines[2][15]).toEqual value: 'HashMap', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'storage.type.beyond']
    expect(lines[2][16]).toEqual value: '<', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'punctuation.bracket.angle.beyond']
    expect(lines[2][17]).toEqual value: '>', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'punctuation.bracket.angle.beyond']
    expect(lines[3][1]).toEqual value: 'CodeMap', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.beyond']
    expect(lines[3][2]).toEqual value: '<', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.angle.beyond']
    expect(lines[3][3]).toEqual value: 'String', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.generic.beyond']
    expect(lines[3][4]).toEqual value: ',', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.separator.delimiter.beyond']
    expect(lines[3][6]).toEqual value: '?', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.generic.wildcard.beyond']
    expect(lines[3][8]).toEqual value: 'extends', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.modifier.extends.beyond']
    expect(lines[3][10]).toEqual value: 'ArrayList', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.generic.beyond']
    expect(lines[3][11]).toEqual value: '>', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.angle.beyond']
    expect(lines[3][13]).toEqual value: 'codemap', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'variable.other.definition.beyond']
    expect(lines[4][1]).toEqual value: 'C', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'entity.name.function.beyond']
    expect(lines[4][3]).toEqual value: 'Map', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'storage.type.beyond']
    expect(lines[4][4]).toEqual value: '<', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'punctuation.bracket.angle.beyond']
    expect(lines[4][5]).toEqual value: '?', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'storage.type.generic.wildcard.beyond']
    expect(lines[4][6]).toEqual value: ',', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'punctuation.separator.delimiter.beyond']
    expect(lines[4][8]).toEqual value: '?', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'storage.type.generic.wildcard.beyond']
    expect(lines[4][10]).toEqual value: 'extends', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'storage.modifier.extends.beyond']
    expect(lines[4][12]).toEqual value: 'List', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'storage.type.beyond']
    expect(lines[4][13]).toEqual value: '<', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'punctuation.bracket.angle.beyond']
    expect(lines[4][14]).toEqual value: '?', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'storage.type.generic.wildcard.beyond']
    expect(lines[4][15]).toEqual value: '>', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'punctuation.bracket.angle.beyond']
    expect(lines[4][16]).toEqual value: '>', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'punctuation.bracket.angle.beyond']
    expect(lines[4][18]).toEqual value: 'm', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'variable.parameter.beyond']
    expect(lines[5][1]).toEqual value: 'Map', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.return-type.beyond', 'storage.type.beyond']
    expect(lines[5][2]).toEqual value: '<', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.return-type.beyond', 'punctuation.bracket.angle.beyond']
    expect(lines[5][3]).toEqual value: 'Integer', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.return-type.beyond', 'storage.type.generic.beyond']
    expect(lines[5][7]).toEqual value: '>', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.return-type.beyond', 'punctuation.bracket.angle.beyond']
    expect(lines[5][9]).toEqual value: 'method', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'entity.name.function.beyond']
    expect(lines[6][1]).toEqual value: 'private', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'storage.modifier.beyond']
    expect(lines[6][3]).toEqual value: 'Object', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.return-type.beyond', 'storage.type.beyond']
    expect(lines[6][5]).toEqual value: 'otherMethod', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'entity.name.function.beyond']
    expect(lines[7][1]).toEqual value: 'Set', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.beyond']
    expect(lines[7][2]).toEqual value: '<', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.angle.beyond']
    expect(lines[7][3]).toEqual value: 'Map', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.generic.beyond']
    expect(lines[7][4]).toEqual value: '.', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.separator.period.beyond']
    expect(lines[7][5]).toEqual value: 'Entry', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.generic.beyond']
    expect(lines[7][6]).toEqual value: '<', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.angle.beyond']
    expect(lines[7][7]).toEqual value: 'K', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.generic.beyond']
    expect(lines[7][8]).toEqual value: ',', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.separator.delimiter.beyond']
    expect(lines[7][10]).toEqual value: 'V', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.generic.beyond']
    expect(lines[7][11]).toEqual value: '>', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.angle.beyond']
    expect(lines[7][12]).toEqual value: '>', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.angle.beyond']
    expect(lines[7][14]).toEqual value: 'set1', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'variable.other.definition.beyond']
    expect(lines[8][1]).toEqual value: 'Set', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.beyond']
    expect(lines[8][2]).toEqual value: '<', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.angle.beyond']
    expect(lines[8][3]).toEqual value: 'java', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.generic.beyond']
    expect(lines[8][4]).toEqual value: '.', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.separator.period.beyond']
    expect(lines[8][5]).toEqual value: 'util', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.generic.beyond']
    expect(lines[8][6]).toEqual value: '.', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.separator.period.beyond']
    expect(lines[8][7]).toEqual value: 'List', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.generic.beyond']
    expect(lines[8][8]).toEqual value: '<', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.angle.beyond']
    expect(lines[8][9]).toEqual value: 'K', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.generic.beyond']
    expect(lines[8][10]).toEqual value: '>', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.angle.beyond']
    expect(lines[8][11]).toEqual value: '>', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.angle.beyond']
    expect(lines[8][13]).toEqual value: 'set2', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'variable.other.definition.beyond']

  it 'tokenizes generics in if-else code block', ->
    lines = grammar.tokenizeLines '''
      void func() {
        int a = 1, A = 2, b = 0;
        if (A < a) {
          b = a;
        }
        String S = "str>str";
      }
    '''

    expect(lines[2][4]).toEqual value: 'A', scopes: ['source.beyond', 'storage.type.beyond']
    expect(lines[2][6]).toEqual value: '<', scopes: ['source.beyond', 'keyword.operator.comparison.beyond']
    expect(lines[5][1]).toEqual value: 'String', scopes: ['source.beyond', 'meta.definition.variable.beyond', 'storage.type.beyond']
    expect(lines[5][3]).toEqual value: 'S', scopes: ['source.beyond', 'meta.definition.variable.beyond', 'variable.other.definition.beyond']
    expect(lines[5][5]).toEqual value: '=', scopes: ['source.beyond', 'keyword.operator.assignment.beyond']
    # check that string does not extend to/include ';'
    expect(lines[5][10]).toEqual value: ';', scopes: ['source.beyond', 'punctuation.terminator.beyond']

  it 'tokenizes generics with multiple conditions in if-else code block', ->
    lines = grammar.tokenizeLines '''
      void func() {
        int a = 1, A = 2, b = 0;
        if (A < a && b < a) {
          b = a;
        }
      }
    '''

    expect(lines[2][4]).toEqual value: 'A', scopes: ['source.beyond', 'storage.type.beyond']
    expect(lines[2][6]).toEqual value: '<', scopes: ['source.beyond', 'keyword.operator.comparison.beyond']
    expect(lines[2][8]).toEqual value: '&&', scopes: ['source.beyond', 'keyword.operator.logical.beyond']
    # 'b' should be just a variable, not part of generic
    expect(lines[2][9]).toEqual value: ' b ', scopes: ['source.beyond']
    expect(lines[2][10]).toEqual value: '<', scopes: ['source.beyond', 'keyword.operator.comparison.beyond']

  it 'tokenizes generics before if-else code block, not including it', ->
    lines = grammar.tokenizeLines '''
      void func() {
        int a = 1, A = 2;
        ArrayList<A extends B<C>> list;
        list = new ArrayList<>();
        if (A < a) { }
      }
    '''

    expect(lines[2][1]).toEqual value: 'ArrayList', scopes: ['source.beyond', 'meta.definition.variable.beyond', 'storage.type.beyond']
    expect(lines[2][2]).toEqual value: '<', scopes: ['source.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.angle.beyond']
    expect(lines[2][3]).toEqual value: 'A', scopes: ['source.beyond', 'meta.definition.variable.beyond', 'storage.type.generic.beyond']
    # "B" is storage.type.java because of the following generic <C>
    expect(lines[2][7]).toEqual value: 'B', scopes: ['source.beyond', 'meta.definition.variable.beyond', 'storage.type.beyond']
    expect(lines[2][9]).toEqual value: 'C', scopes: ['source.beyond', 'meta.definition.variable.beyond', 'storage.type.generic.beyond']
    expect(lines[2][11]).toEqual value: '>', scopes: ['source.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.angle.beyond']
    # right part of the assignment
    expect(lines[3][5]).toEqual value: 'ArrayList', scopes: ['source.beyond', 'storage.type.beyond']
    expect(lines[3][6]).toEqual value: '<', scopes: ['source.beyond', 'punctuation.bracket.angle.beyond']
    expect(lines[3][7]).toEqual value: '>', scopes: ['source.beyond', 'punctuation.bracket.angle.beyond']
    # 'if' code block
    expect(lines[4][4]).toEqual value: 'A', scopes: ['source.beyond', 'storage.type.beyond']
    expect(lines[4][6]).toEqual value: '<', scopes: ['source.beyond', 'keyword.operator.comparison.beyond']

  it 'tokenizes generics after if-else code block, not including it', ->
    lines = grammar.tokenizeLines '''
      void func() {
        if (A < a) {
          a = A;
        }
        ArrayList<A extends B, C> list;
        list = new ArrayList<A extends B, C>();
      }
    '''

    expect(lines[4][1]).toEqual value: 'ArrayList', scopes: ['source.beyond', 'meta.definition.variable.beyond', 'storage.type.beyond']
    expect(lines[4][2]).toEqual value: '<', scopes: ['source.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.angle.beyond']
    expect(lines[4][3]).toEqual value: 'A', scopes: ['source.beyond', 'meta.definition.variable.beyond', 'storage.type.generic.beyond']
    expect(lines[4][7]).toEqual value: 'B', scopes: ['source.beyond', 'meta.definition.variable.beyond', 'storage.type.generic.beyond']
    expect(lines[4][10]).toEqual value: 'C', scopes: ['source.beyond', 'meta.definition.variable.beyond', 'storage.type.generic.beyond']
    expect(lines[4][11]).toEqual value: '>', scopes: ['source.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.angle.beyond']
    # right part of the assignment
    expect(lines[5][5]).toEqual value: 'ArrayList', scopes: ['source.beyond', 'storage.type.beyond']
    expect(lines[5][6]).toEqual value: '<', scopes: ['source.beyond', 'punctuation.bracket.angle.beyond']
    expect(lines[5][7]).toEqual value: 'A', scopes: ['source.beyond', 'storage.type.generic.beyond']
    expect(lines[5][11]).toEqual value: 'B', scopes: ['source.beyond', 'storage.type.generic.beyond']
    expect(lines[5][14]).toEqual value: 'C', scopes: ['source.beyond', 'storage.type.generic.beyond']
    expect(lines[5][15]).toEqual value: '>', scopes: ['source.beyond', 'punctuation.bracket.angle.beyond']

  it 'tokenizes bit shift correctly, not as generics', ->
    lines = grammar.tokenizeLines '''
      void func() {
        int t = 0;
        t = M << 12;
      }
    '''

    expect(lines[2][5]).toEqual value: '<<', scopes: ['source.beyond', 'keyword.operator.bitwise.beyond']
    expect(lines[2][7]).toEqual value: '12', scopes: ['source.beyond', 'constant.numeric.decimal.beyond']

  it 'tokenizes generics as a function return type', ->
    # use function wrapped with class otherwise highlighting is broken
    lines = grammar.tokenizeLines '''
      class Test
      {
        ArrayList<A extends B, C> func() {
          return null;
        }
      }
    '''

    expect(lines[2][1]).toEqual value: 'ArrayList', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.return-type.beyond', 'storage.type.beyond']
    expect(lines[2][2]).toEqual value: '<', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.return-type.beyond', 'punctuation.bracket.angle.beyond']
    expect(lines[2][3]).toEqual value: 'A', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.return-type.beyond', 'storage.type.generic.beyond']
    expect(lines[2][5]).toEqual value: 'extends', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.return-type.beyond', 'storage.modifier.extends.beyond']
    expect(lines[2][7]).toEqual value: 'B', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.return-type.beyond', 'storage.type.generic.beyond']
    expect(lines[2][8]).toEqual value: ',', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.return-type.beyond', 'punctuation.separator.delimiter.beyond']
    expect(lines[2][10]).toEqual value: 'C', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.return-type.beyond', 'storage.type.generic.beyond']
    expect(lines[2][11]).toEqual value: '>', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.return-type.beyond', 'punctuation.bracket.angle.beyond']

  it 'tokenizes generics and primitive arrays declarations', ->
    lines = grammar.tokenizeLines '''
      class A<T> {
        private B<T>[] arr;
        private int[][] two = null;
      }
    '''

    expect(lines[1][1]).toEqual value: 'private', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'storage.modifier.beyond']
    expect(lines[1][3]).toEqual value: 'B', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.beyond']
    expect(lines[1][4]).toEqual value: '<', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.angle.beyond']
    expect(lines[1][5]).toEqual value: 'T', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.generic.beyond']
    expect(lines[1][6]).toEqual value: '>', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.angle.beyond']
    expect(lines[1][7]).toEqual value: '[', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.square.beyond']
    expect(lines[1][8]).toEqual value: ']', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.square.beyond']
    expect(lines[1][10]).toEqual value: 'arr', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'variable.other.definition.beyond']
    expect(lines[1][11]).toEqual value: ';', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'punctuation.terminator.beyond']

    expect(lines[2][1]).toEqual value: 'private', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'storage.modifier.beyond']
    expect(lines[2][3]).toEqual value: 'int', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.primitive.array.beyond']
    expect(lines[2][4]).toEqual value: '[', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.square.beyond']
    expect(lines[2][5]).toEqual value: ']', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.square.beyond']
    expect(lines[2][6]).toEqual value: '[', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.square.beyond']
    expect(lines[2][7]).toEqual value: ']', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.square.beyond']
    expect(lines[2][9]).toEqual value: 'two', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'variable.other.definition.beyond']
    expect(lines[2][11]).toEqual value: '=', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'keyword.operator.assignment.beyond']
    expect(lines[2][13]).toEqual value: 'null', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'constant.language.beyond']
    expect(lines[2][14]).toEqual value: ';', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'punctuation.terminator.beyond']

  it 'tokenizes lambda expressions', ->
    {tokens} = grammar.tokenizeLine '(String s1) -> s1.length() - outer.length();'

    expect(tokens[1]).toEqual value: 'String', scopes: ['source.beyond', 'storage.type.beyond']
    expect(tokens[5]).toEqual value: '->', scopes: ['source.beyond', 'storage.type.function.arrow.beyond']
    expect(tokens[8]).toEqual value: '.', scopes: ['source.beyond', 'meta.method-call.beyond', 'punctuation.separator.period.beyond']
    expect(tokens[10]).toEqual value: '(', scopes: ['source.beyond', 'meta.method-call.beyond', 'punctuation.definition.parameters.begin.bracket.round.beyond']
    expect(tokens[11]).toEqual value: ')', scopes: ['source.beyond', 'meta.method-call.beyond', 'punctuation.definition.parameters.end.bracket.round.beyond']
    expect(tokens[13]).toEqual value: '-', scopes: ['source.beyond', 'keyword.operator.arithmetic.beyond']

  it 'tokenizes `new` statements', ->
    {tokens} = grammar.tokenizeLine 'int[] list = new int[10];'

    expect(tokens[8]).toEqual value: 'new', scopes: ['source.beyond', 'keyword.control.new.beyond']
    expect(tokens[9]).toEqual value: ' ', scopes: ['source.beyond']
    expect(tokens[10]).toEqual value: 'int', scopes: ['source.beyond', 'storage.type.primitive.array.beyond']
    expect(tokens[11]).toEqual value: '[', scopes: ['source.beyond', 'punctuation.bracket.square.beyond']
    expect(tokens[12]).toEqual value: '10', scopes: ['source.beyond', 'constant.numeric.decimal.beyond']
    expect(tokens[13]).toEqual value: ']', scopes: ['source.beyond', 'punctuation.bracket.square.beyond']
    expect(tokens[14]).toEqual value: ';', scopes: ['source.beyond', 'punctuation.terminator.beyond']

    {tokens} = grammar.tokenizeLine 'boolean[] list = new boolean[variable];'

    expect(tokens[12]).toEqual value: 'variable', scopes: ['source.beyond']

    {tokens} = grammar.tokenizeLine 'String[] list = new String[10];'

    expect(tokens[8]).toEqual value: 'new', scopes: ['source.beyond', 'keyword.control.new.beyond']
    expect(tokens[10]).toEqual value: 'String', scopes: ['source.beyond', 'storage.type.object.array.beyond']
    expect(tokens[11]).toEqual value: '[', scopes: ['source.beyond', 'punctuation.bracket.square.beyond']
    expect(tokens[12]).toEqual value: '10', scopes: ['source.beyond', 'constant.numeric.decimal.beyond']
    expect(tokens[13]).toEqual value: ']', scopes: ['source.beyond', 'punctuation.bracket.square.beyond']
    expect(tokens[14]).toEqual value: ';', scopes: ['source.beyond', 'punctuation.terminator.beyond']

    {tokens} = grammar.tokenizeLine 'String[] list = new String[]{"hi", "abc", "etc"};'

    expect(tokens[8]).toEqual value: 'new', scopes: ['source.beyond', 'keyword.control.new.beyond']
    expect(tokens[10]).toEqual value: 'String', scopes: ['source.beyond', 'storage.type.object.array.beyond']
    expect(tokens[13]).toEqual value: '{', scopes: ['source.beyond', 'punctuation.bracket.curly.beyond']
    expect(tokens[14]).toEqual value: '"', scopes: ['source.beyond', 'string.quoted.double.beyond', 'punctuation.definition.string.begin.beyond']
    expect(tokens[15]).toEqual value: 'hi', scopes: ['source.beyond', 'string.quoted.double.beyond']
    expect(tokens[16]).toEqual value: '"', scopes: ['source.beyond', 'string.quoted.double.beyond', 'punctuation.definition.string.end.beyond']
    expect(tokens[17]).toEqual value: ',', scopes: ['source.beyond', 'punctuation.separator.delimiter.beyond']
    expect(tokens[18]).toEqual value: ' ', scopes: ['source.beyond']
    expect(tokens[27]).toEqual value: '}', scopes: ['source.beyond', 'punctuation.bracket.curly.beyond']
    expect(tokens[28]).toEqual value: ';', scopes: ['source.beyond', 'punctuation.terminator.beyond']

    {tokens} = grammar.tokenizeLine 'A[] arr = new A[]{new A(), new A()};'

    expect(tokens[8]).toEqual value: 'new', scopes: ['source.beyond', 'keyword.control.new.beyond']
    expect(tokens[10]).toEqual value: 'A', scopes: ['source.beyond', 'storage.type.object.array.beyond']
    expect(tokens[13]).toEqual value: '{', scopes: ['source.beyond', 'punctuation.bracket.curly.beyond']
    expect(tokens[14]).toEqual value: 'new', scopes: ['source.beyond', 'keyword.control.new.beyond']
    expect(tokens[16]).toEqual value: 'A', scopes: ['source.beyond', 'meta.function-call.beyond', 'entity.name.function.beyond']
    expect(tokens[17]).toEqual value: '(', scopes: ['source.beyond', 'meta.function-call.beyond', 'punctuation.definition.parameters.begin.bracket.round.beyond']
    expect(tokens[18]).toEqual value: ')', scopes: ['source.beyond', 'meta.function-call.beyond', 'punctuation.definition.parameters.end.bracket.round.beyond']
    expect(tokens[21]).toEqual value: 'new', scopes: ['source.beyond', 'keyword.control.new.beyond']
    expect(tokens[23]).toEqual value: 'A', scopes: ['source.beyond', 'meta.function-call.beyond', 'entity.name.function.beyond']
    expect(tokens[24]).toEqual value: '(', scopes: ['source.beyond', 'meta.function-call.beyond', 'punctuation.definition.parameters.begin.bracket.round.beyond']
    expect(tokens[25]).toEqual value: ')', scopes: ['source.beyond', 'meta.function-call.beyond', 'punctuation.definition.parameters.end.bracket.round.beyond']
    expect(tokens[26]).toEqual value: '}', scopes: ['source.beyond', 'punctuation.bracket.curly.beyond']
    expect(tokens[27]).toEqual value: ';', scopes: ['source.beyond', 'punctuation.terminator.beyond']

    {tokens} = grammar.tokenizeLine 'A[] arr = {new A(), new A()};'

    expect(tokens[8]).toEqual value: '{', scopes: ['source.beyond', 'punctuation.section.block.begin.bracket.curly.beyond']
    expect(tokens[9]).toEqual value: 'new', scopes: ['source.beyond', 'keyword.control.new.beyond']
    expect(tokens[11]).toEqual value: 'A', scopes: ['source.beyond', 'meta.function-call.beyond', 'entity.name.function.beyond']
    expect(tokens[12]).toEqual value: '(', scopes: ['source.beyond', 'meta.function-call.beyond', 'punctuation.definition.parameters.begin.bracket.round.beyond']
    expect(tokens[13]).toEqual value: ')', scopes: ['source.beyond', 'meta.function-call.beyond', 'punctuation.definition.parameters.end.bracket.round.beyond']
    expect(tokens[16]).toEqual value: 'new', scopes: ['source.beyond', 'keyword.control.new.beyond']
    expect(tokens[18]).toEqual value: 'A', scopes: ['source.beyond', 'meta.function-call.beyond', 'entity.name.function.beyond']
    expect(tokens[19]).toEqual value: '(', scopes: ['source.beyond', 'meta.function-call.beyond', 'punctuation.definition.parameters.begin.bracket.round.beyond']
    expect(tokens[20]).toEqual value: ')', scopes: ['source.beyond', 'meta.function-call.beyond', 'punctuation.definition.parameters.end.bracket.round.beyond']
    expect(tokens[21]).toEqual value: '}', scopes: ['source.beyond', 'punctuation.section.block.end.bracket.curly.beyond']
    expect(tokens[22]).toEqual value: ';', scopes: ['source.beyond', 'punctuation.terminator.beyond']

    {tokens} = grammar.tokenizeLine 'String a = (valid ? new Date().toString() + " : " : "");'

    expect(tokens[16]).toEqual value: 'toString', scopes: ['source.beyond', 'meta.function-call.beyond', 'entity.name.function.beyond']
    expect(tokens[17]).toEqual value: '(', scopes: ['source.beyond', 'meta.function-call.beyond', 'punctuation.definition.parameters.begin.bracket.round.beyond']
    expect(tokens[18]).toEqual value: ')', scopes: ['source.beyond', 'meta.function-call.beyond', 'punctuation.definition.parameters.end.bracket.round.beyond']
    expect(tokens[20]).toEqual value: '+', scopes: ['source.beyond', 'keyword.operator.arithmetic.beyond']
    expect(tokens[23]).toEqual value: ' : ', scopes: ['source.beyond', 'string.quoted.double.beyond']
    expect(tokens[26]).toEqual value: ':', scopes: ['source.beyond', 'keyword.control.ternary.beyond']
    expect(tokens[28]).toEqual value: '"', scopes: ['source.beyond', 'string.quoted.double.beyond', 'punctuation.definition.string.begin.beyond']
    expect(tokens[29]).toEqual value: '"', scopes: ['source.beyond', 'string.quoted.double.beyond', 'punctuation.definition.string.end.beyond']

    {tokens} = grammar.tokenizeLine 'String[] list = new String[variable];'

    expect(tokens[12]).toEqual value: 'variable', scopes: ['source.beyond']

    {tokens} = grammar.tokenizeLine 'Point point = new Point(1, 4);'

    expect(tokens[6]).toEqual value: 'new', scopes: ['source.beyond', 'keyword.control.new.beyond']
    expect(tokens[8]).toEqual value: 'Point', scopes: ['source.beyond', 'meta.function-call.beyond', 'entity.name.function.beyond']
    expect(tokens[9]).toEqual value: '(', scopes: ['source.beyond', 'meta.function-call.beyond', 'punctuation.definition.parameters.begin.bracket.round.beyond']
    expect(tokens[14]).toEqual value: ')', scopes: ['source.beyond', 'meta.function-call.beyond', 'punctuation.definition.parameters.end.bracket.round.beyond']
    expect(tokens[15]).toEqual value: ';', scopes: ['source.beyond', 'punctuation.terminator.beyond']

    {tokens} = grammar.tokenizeLine 'Point point = true ? new Point(1, 4) : new Point(0, 0);'

    expect(tokens[8]).toEqual value: '?', scopes: ['source.beyond', 'keyword.control.ternary.beyond']
    expect(tokens[10]).toEqual value: 'new', scopes: ['source.beyond', 'keyword.control.new.beyond']
    expect(tokens[12]).toEqual value: 'Point', scopes: ['source.beyond', 'meta.function-call.beyond', 'entity.name.function.beyond']
    expect(tokens[13]).toEqual value: '(', scopes: ['source.beyond', 'meta.function-call.beyond', 'punctuation.definition.parameters.begin.bracket.round.beyond']
    expect(tokens[18]).toEqual value: ')', scopes: ['source.beyond', 'meta.function-call.beyond', 'punctuation.definition.parameters.end.bracket.round.beyond']
    expect(tokens[20]).toEqual value: ':', scopes: ['source.beyond', 'keyword.control.ternary.beyond']
    expect(tokens[22]).toEqual value: 'new', scopes: ['source.beyond', 'keyword.control.new.beyond']
    expect(tokens[31]).toEqual value: ';', scopes: ['source.beyond', 'punctuation.terminator.beyond']

    {tokens} = grammar.tokenizeLine 'map.put(key, new Value(value), "extra");'

    expect(tokens[12]).toEqual value: ')', scopes: ['source.beyond', 'meta.method-call.beyond', 'meta.function-call.beyond', 'punctuation.definition.parameters.end.bracket.round.beyond']
    expect(tokens[13]).toEqual value: ',', scopes: ['source.beyond', 'meta.method-call.beyond', 'punctuation.separator.delimiter.beyond']
    expect(tokens[15]).toEqual value: '"', scopes: ['source.beyond', 'meta.method-call.beyond', 'string.quoted.double.beyond', 'punctuation.definition.string.begin.beyond']
    expect(tokens[18]).toEqual value: ')', scopes: ['source.beyond', 'meta.method-call.beyond', 'punctuation.definition.parameters.end.bracket.round.beyond']

    {tokens} = grammar.tokenizeLine 'new /* JPanel() */ Point();'

    expect(tokens[0]).toEqual value: 'new', scopes: ['source.beyond', 'keyword.control.new.beyond']
    expect(tokens[2]).toEqual value: '/*', scopes: ['source.beyond', 'comment.block.beyond', 'punctuation.definition.comment.beyond']
    expect(tokens[4]).toEqual value: '*/', scopes: ['source.beyond', 'comment.block.beyond', 'punctuation.definition.comment.beyond']
    expect(tokens[6]).toEqual value: 'Point', scopes: ['source.beyond', 'meta.function-call.beyond', 'entity.name.function.beyond']
    expect(tokens[9]).toEqual value: ';', scopes: ['source.beyond', 'punctuation.terminator.beyond']

    lines = grammar.tokenizeLines '''
      map.put(key,
        new Value(value)
      );
      '''

    expect(lines[2][0]).toEqual value: ')', scopes: ['source.beyond', 'meta.method-call.beyond', 'punctuation.definition.parameters.end.bracket.round.beyond']

    lines = grammar.tokenizeLines '''
      Point point = new Point()
      {
        public void something(x)
        {
          int y = x;
        }
      };
      '''

    expect(lines[0][6]).toEqual value: 'new', scopes: ['source.beyond', 'keyword.control.new.beyond']
    expect(lines[0][8]).toEqual value: 'Point', scopes: ['source.beyond', 'meta.function-call.beyond', 'entity.name.function.beyond']
    expect(lines[1][0]).toEqual value: '{', scopes: ['source.beyond', 'meta.inner-class.beyond', 'punctuation.section.inner-class.begin.bracket.curly.beyond']
    expect(lines[2][1]).toEqual value: 'public', scopes: ['source.beyond', 'meta.inner-class.beyond', 'meta.method.beyond', 'storage.modifier.beyond']
    expect(lines[4][1]).toEqual value: 'int', scopes: ['source.beyond', 'meta.inner-class.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'meta.definition.variable.beyond', 'storage.type.primitive.beyond']
    expect(lines[6][0]).toEqual value: '}', scopes: ['source.beyond', 'meta.inner-class.beyond', 'punctuation.section.inner-class.end.bracket.curly.beyond']
    expect(lines[6][1]).toEqual value: ';', scopes: ['source.beyond', 'punctuation.terminator.beyond']

  it 'tokenizes class fields', ->
    lines = grammar.tokenizeLines '''
      class Test
      {
        private int variable;
        public Object[] variable;
        private int variable = 3;
        private int variable1, variable2, variable3;
        private int variable1, variable2 = variable;
        private int variable;// = 3;
        public String CAPITALVARIABLE;
        private int[][] somevar = new int[10][12];
        private int 1invalid;
        private Integer $tar_war$;
        double a,b,c;double d;
        String[] primitiveArray;
        private Foo<int[]> hi;
        Foo<int[]> hi;
      }
      '''

    expect(lines[2][1]).toEqual value: 'private', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'storage.modifier.beyond']
    expect(lines[2][2]).toEqual value: ' ', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond']
    expect(lines[2][3]).toEqual value: 'int', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.primitive.beyond']
    expect(lines[2][4]).toEqual value: ' ', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond']
    expect(lines[2][5]).toEqual value: 'variable', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'variable.other.definition.beyond']
    expect(lines[2][6]).toEqual value: ';', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'punctuation.terminator.beyond']

    expect(lines[3][1]).toEqual value: 'public', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'storage.modifier.beyond']
    expect(lines[3][3]).toEqual value: 'Object', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.object.array.beyond']
    expect(lines[3][4]).toEqual value: '[', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.square.beyond']
    expect(lines[3][5]).toEqual value: ']', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.square.beyond']

    expect(lines[4][5]).toEqual value: 'variable', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'variable.other.definition.beyond']
    expect(lines[4][6]).toEqual value: ' ', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond']
    expect(lines[4][7]).toEqual value: '=', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'keyword.operator.assignment.beyond']
    expect(lines[4][8]).toEqual value: ' ', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond']
    expect(lines[4][9]).toEqual value: '3', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'constant.numeric.decimal.beyond']
    expect(lines[4][10]).toEqual value: ';', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'punctuation.terminator.beyond']

    expect(lines[5][5]).toEqual value: 'variable1', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'variable.other.definition.beyond']
    expect(lines[5][6]).toEqual value: ',', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.separator.delimiter.beyond']
    expect(lines[5][7]).toEqual value: ' ', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond']
    expect(lines[5][8]).toEqual value: 'variable2', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'variable.other.definition.beyond']
    expect(lines[5][11]).toEqual value: 'variable3', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'variable.other.definition.beyond']
    expect(lines[5][12]).toEqual value: ';', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'punctuation.terminator.beyond']

    expect(lines[6][5]).toEqual value: 'variable1', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'variable.other.definition.beyond']
    expect(lines[6][8]).toEqual value: 'variable2', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'variable.other.definition.beyond']
    expect(lines[6][10]).toEqual value: '=', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'keyword.operator.assignment.beyond']
    expect(lines[6][11]).toEqual value: ' variable', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond']
    expect(lines[6][12]).toEqual value: ';', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'punctuation.terminator.beyond']

    expect(lines[7][5]).toEqual value: 'variable', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'variable.other.definition.beyond']
    expect(lines[7][6]).toEqual value: ';', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'punctuation.terminator.beyond']
    expect(lines[7][7]).toEqual value: '//', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'comment.line.double-slash.beyond', 'punctuation.definition.comment.beyond']

    expect(lines[8][5]).toEqual value: 'CAPITALVARIABLE', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'variable.other.definition.beyond']
    expect(lines[8][6]).toEqual value: ';', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'punctuation.terminator.beyond']

    expect(lines[9][3]).toEqual value: 'int', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.primitive.array.beyond']
    expect(lines[9][4]).toEqual value: '[', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.square.beyond']
    expect(lines[9][5]).toEqual value: ']', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.square.beyond']
    expect(lines[9][6]).toEqual value: '[', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.square.beyond']
    expect(lines[9][7]).toEqual value: ']', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.square.beyond']
    expect(lines[9][9]).toEqual value: 'somevar', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'variable.other.definition.beyond']
    expect(lines[9][11]).toEqual value: '=', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'keyword.operator.assignment.beyond']
    expect(lines[9][15]).toEqual value: 'int', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'storage.type.primitive.array.beyond']
    expect(lines[9][16]).toEqual value: '[', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'punctuation.bracket.square.beyond']
    expect(lines[9][17]).toEqual value: '10', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'constant.numeric.decimal.beyond']
    expect(lines[9][18]).toEqual value: ']', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'punctuation.bracket.square.beyond']
    expect(lines[9][19]).toEqual value: '[', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'punctuation.bracket.square.beyond']
    expect(lines[9][20]).toEqual value: '12', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'constant.numeric.decimal.beyond']
    expect(lines[9][21]).toEqual value: ']', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'punctuation.bracket.square.beyond']

    expect(lines[10][2]).toEqual value: ' int 1invalid', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond']

    expect(lines[11][3]).toEqual value: 'Integer', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.beyond']
    expect(lines[11][5]).toEqual value: '$tar_war$', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'variable.other.definition.beyond']

    expect(lines[12][1]).toEqual value: 'double', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.primitive.beyond']
    expect(lines[12][3]).toEqual value: 'a', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'variable.other.definition.beyond']
    expect(lines[12][4]).toEqual value: ',', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.separator.delimiter.beyond']
    expect(lines[12][5]).toEqual value: 'b', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'variable.other.definition.beyond']
    expect(lines[12][6]).toEqual value: ',', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.separator.delimiter.beyond']
    expect(lines[12][7]).toEqual value: 'c', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'variable.other.definition.beyond']
    expect(lines[12][8]).toEqual value: ';', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'punctuation.terminator.beyond']
    expect(lines[12][9]).toEqual value: 'double', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.primitive.beyond']
    expect(lines[12][11]).toEqual value: 'd', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'variable.other.definition.beyond']
    expect(lines[12][12]).toEqual value: ';', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'punctuation.terminator.beyond']

    expect(lines[13][1]).toEqual value: 'String', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.object.array.beyond']
    expect(lines[13][2]).toEqual value: '[', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.square.beyond']
    expect(lines[13][3]).toEqual value: ']', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.square.beyond']
    expect(lines[13][5]).toEqual value: 'primitiveArray', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'variable.other.definition.beyond']

    expect(lines[14][1]).toEqual value: 'private', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'storage.modifier.beyond']
    expect(lines[14][3]).toEqual value: 'Foo', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.beyond']
    expect(lines[14][4]).toEqual value: '<', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.angle.beyond']
    expect(lines[14][5]).toEqual value: 'int', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.primitive.array.beyond']
    expect(lines[14][6]).toEqual value: '[', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.square.beyond']
    expect(lines[14][7]).toEqual value: ']', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.square.beyond']
    expect(lines[14][8]).toEqual value: '>', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.angle.beyond']

    expect(lines[15][1]).toEqual value: 'Foo', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.beyond']
    expect(lines[15][2]).toEqual value: '<', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.angle.beyond']
    expect(lines[15][3]).toEqual value: 'int', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.primitive.array.beyond']
    expect(lines[15][4]).toEqual value: '[', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.square.beyond']
    expect(lines[15][5]).toEqual value: ']', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.square.beyond']
    expect(lines[15][6]).toEqual value: '>', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.angle.beyond']

  it 'tokenizes qualified storage types', ->
    lines = grammar.tokenizeLines '''
      class Test {
        private Test.Double something;
        java.util.Set<java.util.List<K>> varA = null;
        java.lang.String a = null;
        java.util.List<Integer> b = new java.util.ArrayList<Integer>();
        java.lang.String[] arr;
      }
    '''
    expect(lines[1][3]).toEqual value: 'Test', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.beyond']
    expect(lines[1][4]).toEqual value: '.', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.separator.period.beyond']
    expect(lines[1][5]).toEqual value: 'Double', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.beyond']
    expect(lines[1][7]).toEqual value: 'something', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'variable.other.definition.beyond']

    expect(lines[2][1]).toEqual value: 'java', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.beyond']
    expect(lines[2][2]).toEqual value: '.', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.separator.period.beyond']
    expect(lines[2][3]).toEqual value: 'util', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.beyond']
    expect(lines[2][4]).toEqual value: '.', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.separator.period.beyond']
    expect(lines[2][5]).toEqual value: 'Set', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.beyond']
    expect(lines[2][6]).toEqual value: '<', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.angle.beyond']
    expect(lines[2][7]).toEqual value: 'java', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.generic.beyond']
    expect(lines[2][8]).toEqual value: '.', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.separator.period.beyond']
    expect(lines[2][9]).toEqual value: 'util', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.generic.beyond']
    expect(lines[2][10]).toEqual value: '.', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.separator.period.beyond']
    expect(lines[2][11]).toEqual value: 'List', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.generic.beyond']
    expect(lines[2][12]).toEqual value: '<', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.angle.beyond']
    expect(lines[2][13]).toEqual value: 'K', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.generic.beyond']
    expect(lines[2][14]).toEqual value: '>', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.angle.beyond']
    expect(lines[2][15]).toEqual value: '>', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.angle.beyond']

    expect(lines[3][1]).toEqual value: 'java', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.beyond']
    expect(lines[3][2]).toEqual value: '.', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.separator.period.beyond']
    expect(lines[3][3]).toEqual value: 'lang', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.beyond']
    expect(lines[3][4]).toEqual value: '.', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.separator.period.beyond']
    expect(lines[3][5]).toEqual value: 'String', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.beyond']

    expect(lines[4][1]).toEqual value: 'java', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.beyond']
    expect(lines[4][2]).toEqual value: '.', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.separator.period.beyond']
    expect(lines[4][3]).toEqual value: 'util', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.beyond']
    expect(lines[4][4]).toEqual value: '.', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.separator.period.beyond']
    expect(lines[4][5]).toEqual value: 'List', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.beyond']
    expect(lines[4][6]).toEqual value: '<', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.angle.beyond']
    expect(lines[4][7]).toEqual value: 'Integer', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.generic.beyond']
    expect(lines[4][8]).toEqual value: '>', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.angle.beyond']
    expect(lines[4][16]).toEqual value: 'java', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'storage.type.beyond']
    expect(lines[4][17]).toEqual value: '.', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'punctuation.separator.period.beyond']
    expect(lines[4][18]).toEqual value: 'util', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'storage.type.beyond']
    expect(lines[4][19]).toEqual value: '.', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'punctuation.separator.period.beyond']
    expect(lines[4][20]).toEqual value: 'ArrayList', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'storage.type.beyond']
    expect(lines[4][21]).toEqual value: '<', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'punctuation.bracket.angle.beyond']
    expect(lines[4][22]).toEqual value: 'Integer', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'storage.type.generic.beyond']
    expect(lines[4][23]).toEqual value: '>', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'punctuation.bracket.angle.beyond']

    expect(lines[5][1]).toEqual value: 'java', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.beyond']
    expect(lines[5][2]).toEqual value: '.', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.separator.period.beyond']
    expect(lines[5][3]).toEqual value: 'lang', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.beyond']
    expect(lines[5][4]).toEqual value: '.', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.separator.period.beyond']
    expect(lines[5][5]).toEqual value: 'String', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.object.array.beyond']
    expect(lines[5][6]).toEqual value: '[', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.square.beyond']
    expect(lines[5][7]).toEqual value: ']', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'punctuation.bracket.square.beyond']

  it 'tokenizes comment inside method body', ->
    lines = grammar.tokenizeLines '''
      class Test
      {
        private void method() {
          /** invalid javadoc comment */
          /* inline comment */
          // single-line comment
        }
      }
      '''

    expect(lines[3][1]).toEqual value: '/*', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'comment.block.beyond', 'punctuation.definition.comment.beyond']
    expect(lines[3][2]).toEqual value: '* invalid javadoc comment ', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'comment.block.beyond']
    expect(lines[3][3]).toEqual value: '*/', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'comment.block.beyond', 'punctuation.definition.comment.beyond']

    expect(lines[4][1]).toEqual value: '/*', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'comment.block.beyond', 'punctuation.definition.comment.beyond']
    expect(lines[4][2]).toEqual value: ' inline comment ', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'comment.block.beyond']
    expect(lines[4][3]).toEqual value: '*/', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'comment.block.beyond', 'punctuation.definition.comment.beyond']

    expect(lines[5][1]).toEqual value: '//', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'comment.line.double-slash.beyond', 'punctuation.definition.comment.beyond']
    expect(lines[5][2]).toEqual value: ' single-line comment', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'comment.line.double-slash.beyond']

  it 'tokenizes empty/single character comment', ->
    # this test checks the correct tokenizing of empty/single character comments
    # comment like /**/ should be parsed as single line comment, but /***/ should be parsed as javadoc
    lines = grammar.tokenizeLines '''
      /**/ int a = 1;
      /**/ int b = 1;
      /**/ int c = 1;
      /**/ int d = 1;

      /***/ int e = 1;
      /**/ int f = 1;
      /** */ int g = 1;
      /* */ int h = 1;
      '''

    expect(lines[0][0]).toEqual value: '/**/', scopes: ['source.beyond', 'comment.block.empty.beyond', 'punctuation.definition.comment.beyond']
    expect(lines[0][2]).toEqual value: 'int', scopes: ['source.beyond', 'meta.definition.variable.beyond', 'storage.type.primitive.beyond']
    expect(lines[1][0]).toEqual value: '/**/', scopes: ['source.beyond', 'comment.block.empty.beyond', 'punctuation.definition.comment.beyond']
    expect(lines[1][2]).toEqual value: 'int', scopes: ['source.beyond', 'meta.definition.variable.beyond', 'storage.type.primitive.beyond']
    expect(lines[2][0]).toEqual value: '/**/', scopes: ['source.beyond', 'comment.block.empty.beyond', 'punctuation.definition.comment.beyond']
    expect(lines[2][2]).toEqual value: 'int', scopes: ['source.beyond', 'meta.definition.variable.beyond', 'storage.type.primitive.beyond']
    expect(lines[3][0]).toEqual value: '/**/', scopes: ['source.beyond', 'comment.block.empty.beyond', 'punctuation.definition.comment.beyond']
    expect(lines[3][2]).toEqual value: 'int', scopes: ['source.beyond', 'meta.definition.variable.beyond', 'storage.type.primitive.beyond']

    #expect(lines[5][0]).toEqual value: '/**', scopes: ['source.beyond', 'comment.block.beyond', 'punctuation.definition.comment.beyond']
    #expect(lines[5][1]).toEqual value: '*/', scopes: ['source.beyond', 'comment.block.beyond', 'punctuation.definition.comment.beyond']
    expect(lines[6][0]).toEqual value: '/**/', scopes: ['source.beyond', 'comment.block.empty.beyond', 'punctuation.definition.comment.beyond']
    expect(lines[6][2]).toEqual value: 'int', scopes: ['source.beyond', 'meta.definition.variable.beyond', 'storage.type.primitive.beyond']
    #expect(lines[7][0]).toEqual value: '/**', scopes: ['source.beyond', 'comment.block.beyond', 'punctuation.definition.comment.beyond']
    expect(lines[7][2]).toEqual value: '*/', scopes: ['source.beyond', 'comment.block.beyond', 'punctuation.definition.comment.beyond']
    expect(lines[8][0]).toEqual value: '/*', scopes: ['source.beyond', 'comment.block.beyond', 'punctuation.definition.comment.beyond']
    expect(lines[8][2]).toEqual value: '*/', scopes: ['source.beyond', 'comment.block.beyond', 'punctuation.definition.comment.beyond']

  it 'tokenizes inline comment inside method signature', ->
    # this checks usage of inline /*...*/ comments mixing with parameters
    lines = grammar.tokenizeLines '''
      class A
      {
        public A(int a, /* String b,*/ boolean c) { }

        public void methodA(int a /*, String b */) { }

        private void methodB(/* int a, */String b) { }

        protected void methodC(/* comment */) { }
      }
      '''

    expect(lines[2][1]).toEqual value: 'public', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'storage.modifier.beyond']
    expect(lines[2][3]).toEqual value: 'A', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'entity.name.function.beyond']
    expect(lines[2][4]).toEqual value: '(', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'punctuation.definition.parameters.begin.bracket.round.beyond']
    expect(lines[2][5]).toEqual value: 'int', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'storage.type.primitive.beyond']
    expect(lines[2][7]).toEqual value: 'a', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'variable.parameter.beyond']
    expect(lines[2][8]).toEqual value: ',', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'punctuation.separator.delimiter.beyond']
    expect(lines[2][10]).toEqual value: '/*', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'comment.block.beyond', 'punctuation.definition.comment.beyond']
    expect(lines[2][11]).toEqual value: ' String b,', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'comment.block.beyond']
    expect(lines[2][12]).toEqual value: '*/', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'comment.block.beyond', 'punctuation.definition.comment.beyond']
    expect(lines[2][14]).toEqual value: 'boolean', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'storage.type.primitive.beyond']
    expect(lines[2][16]).toEqual value: 'c', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'variable.parameter.beyond']
    expect(lines[2][17]).toEqual value: ')', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'punctuation.definition.parameters.end.bracket.round.beyond']

    expect(lines[4][6]).toEqual value: '(', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'punctuation.definition.parameters.begin.bracket.round.beyond']
    expect(lines[4][7]).toEqual value: 'int', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'storage.type.primitive.beyond']
    expect(lines[4][9]).toEqual value: 'a', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'variable.parameter.beyond']
    expect(lines[4][11]).toEqual value: '/*', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'comment.block.beyond', 'punctuation.definition.comment.beyond']
    expect(lines[4][12]).toEqual value: ', String b ', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'comment.block.beyond']
    expect(lines[4][13]).toEqual value: '*/', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'comment.block.beyond', 'punctuation.definition.comment.beyond']
    expect(lines[4][14]).toEqual value: ')', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'punctuation.definition.parameters.end.bracket.round.beyond']

    expect(lines[6][6]).toEqual value: '(', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'punctuation.definition.parameters.begin.bracket.round.beyond']
    expect(lines[6][7]).toEqual value: '/*', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'comment.block.beyond', 'punctuation.definition.comment.beyond']
    expect(lines[6][8]).toEqual value: ' int a, ', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'comment.block.beyond']
    expect(lines[6][9]).toEqual value: '*/', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'comment.block.beyond', 'punctuation.definition.comment.beyond']
    expect(lines[6][10]).toEqual value: 'String', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'storage.type.beyond']
    expect(lines[6][12]).toEqual value: 'b', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'variable.parameter.beyond']
    expect(lines[6][13]).toEqual value: ')', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'punctuation.definition.parameters.end.bracket.round.beyond']

    expect(lines[8][6]).toEqual value: '(', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'punctuation.definition.parameters.begin.bracket.round.beyond']
    expect(lines[8][7]).toEqual value: '/*', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'comment.block.beyond', 'punctuation.definition.comment.beyond']
    expect(lines[8][8]).toEqual value: ' comment ', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'comment.block.beyond']
    expect(lines[8][9]).toEqual value: '*/', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'comment.block.beyond', 'punctuation.definition.comment.beyond']
    expect(lines[8][10]).toEqual value: ')', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.identifier.beyond', 'punctuation.definition.parameters.end.bracket.round.beyond']

  it 'tokenizes class-body block initializer', ->
    lines = grammar.tokenizeLines '''
      class Test
      {
        public static HashSet<Integer> set = new HashSet<Integer>();
        {
          int a = 1;
          set.add(a);
        }
      }
      '''

    expect(lines[3][1]).toEqual value: '{', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'punctuation.section.block.begin.bracket.curly.beyond']
    expect(lines[4][1]).toEqual value: 'int', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.primitive.beyond']
    expect(lines[4][3]).toEqual value: 'a', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'variable.other.definition.beyond']
    expect(lines[5][1]).toEqual value: 'set', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'variable.other.object.beyond']
    expect(lines[5][3]).toEqual value: 'add', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method-call.beyond', 'entity.name.function.beyond']
    expect(lines[6][1]).toEqual value: '}', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'punctuation.section.block.end.bracket.curly.beyond']

  it 'tokenizes method-body block initializer', ->
    lines = grammar.tokenizeLines '''
      class Test
      {
        public int func() {
          List<Integer> list = new ArrayList<Integer>();
          {
            int a = 1;
            list.add(a);
          }
          return 1;
        }
      }
      '''

    expect(lines[4][1]).toEqual value: '{', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'punctuation.section.block.begin.bracket.curly.beyond']
    expect(lines[5][1]).toEqual value: 'int', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'meta.definition.variable.beyond', 'storage.type.primitive.beyond']
    expect(lines[5][3]).toEqual value: 'a', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'meta.definition.variable.beyond', 'variable.other.definition.beyond']
    expect(lines[6][1]).toEqual value: 'list', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'variable.other.object.beyond']
    expect(lines[6][3]).toEqual value: 'add', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'meta.method-call.beyond', 'entity.name.function.beyond']
    expect(lines[7][1]).toEqual value: '}', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method.beyond', 'meta.method.body.beyond', 'punctuation.section.block.end.bracket.curly.beyond']

  it 'tokenizes static initializer', ->
    lines = grammar.tokenizeLines '''
      class Test
      {
        public static HashSet<Integer> set = new HashSet<Integer>();
        static {
          int a = 1;
          set.add(a);
        }
      }
      '''

    expect(lines[3][1]).toEqual value: 'static', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'storage.modifier.beyond']
    expect(lines[3][3]).toEqual value: '{', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'punctuation.section.block.begin.bracket.curly.beyond']
    expect(lines[4][1]).toEqual value: 'int', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'storage.type.primitive.beyond']
    expect(lines[4][3]).toEqual value: 'a', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.definition.variable.beyond', 'variable.other.definition.beyond']
    expect(lines[5][1]).toEqual value: 'set', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'variable.other.object.beyond']
    expect(lines[5][3]).toEqual value: 'add', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'meta.method-call.beyond', 'entity.name.function.beyond']
    expect(lines[6][1]).toEqual value: '}', scopes: ['source.beyond', 'meta.class.beyond', 'meta.class.body.beyond', 'punctuation.section.block.end.bracket.curly.beyond']
