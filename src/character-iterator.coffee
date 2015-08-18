TokenIterator = require "../src/token-iterator"

module.exports =
class CharacterIterator
  constructor: (lineState) ->
    @tokenIterator = new TokenIterator
    @reset(lineState) if lineState?

  reset: (@lineState) ->
    @tokenIterator.reset(lineState)
    @lineCharIndex = 0
    @currentCharLength = 0
    @tokenTextIndex = 0
    @tokenText = ""

  getScopes: ->
    @tokenIterator.getScopes()

  getScopeStarts: ->
    @tokenIterator.getScopeStarts()

  getScopeEnds: ->
    @tokenIterator.getScopeEnds()

  getTokenStart: ->
    @tokenStart

  getTokenEnd: ->
    @tokenEnd

  next: ->
    @isNewToken = false
    @tokenTextIndex += @currentCharLength
    @lineCharIndex  += @currentCharLength

    if @tokenTextIndex >= @tokenText.length
      return false unless @tokenIterator.next()

      @isNewToken = true
      @tokenText = @tokenIterator.getText()
      @tokenStart = @tokenIterator.getScreenStart()
      @tokenEnd = @tokenIterator.getScreenEnd()
      @tokenTextIndex = 0

    if @tokenIterator.isPairedCharacter()
      @currentChar = @tokenText
      @currentCharLength = 2
    else
      @currentChar = @tokenText[@tokenTextIndex]
      @currentCharLength = 1

    true

  getChar: ->
    @currentChar or ""

  getCharIndex: ->
    @lineCharIndex

  getTokenText: ->
    @tokenText

  getCharIndexWithinToken: ->
    @tokenTextIndex

  isHardTab: ->
    @tokenIterator.isHardTab()

  beginsNewToken: ->
    @isNewToken

  beginsLeadingWhitespace: ->
    @lineCharIndex < @lineState.firstNonWhitespaceIndex and @tokenTextIndex is 0

  endsLeadingWhitespace: ->
    @lineCharIndex + @currentCharLength is @lineState.firstNonWhitespaceIndex or
    (@tokenTextIndex + @currentCharLength is @tokenText.length and @lineCharIndex + @currentCharLength < @lineState.firstNonWhitespaceIndex)

  beginsTrailingWhitespace: ->
    @lineCharIndex is @lineState.firstTrailingWhitespaceIndex

  endsTrailingWhitespace: ->
    @lineCharIndex + @currentCharLength is @lineState.text.length