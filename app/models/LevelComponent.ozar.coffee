CocoModel = require './CocoModel'

module.exports = class LevelComponent extends CocoModel
  @className: 'LevelComponent'
  @schema: require 'schemas/models/level_component'

  @EquipsID: '53e217d253457600003e3ebb'
  @ItemID: '53e12043b82921000051cdf9'
  @AttacksID: '524b7ba57fc0f6d519000016'
  @PhysicalID: '524b75ad7fc0f6d519000001'
  @ExistsID: '524b4150ff92f1f4f8000024'
  @LandID: '524b7aff7fc0f6d519000006'
  @CollidesID: '524b7b857fc0f6d519000012'
  @PlansID: '524b7b517fc0f6d51900000d'
  @ProgrammableID: '524b7b5a7fc0f6d51900000e'
  @MovesID: '524b7b8c7fc0f6d519000013'
  @MissileID: '524cc2593ea855e0ab000142'
  @FindsPathsID: '52872b0ead92b98561000002'
  @AttackableID: '524b7bab7fc0f6d519000017'
  @RefereeID: '54977ce657e90bd1903dea72'

  @ProgrammableIDs = [
    '524b7b5a7fc0f6d51900000e',
    '5f7d7be6bad19a002837b394'
  ]
  

  @positionIDs = [
    '524b75ad7fc0f6d519000001',
    '5f589b061d240e002298f852'
  ]
  @shapeIDs = [
    '524b75ad7fc0f6d519000001',
    '5f58cbfe3f40380023b02f3c'
  ]
  @collisionIDs = [
    '524b7b857fc0f6d519000012',
    '5f5a19ba36dd000023f89f7b'
  ]


  urlRoot: '/db/level.component'
  editableByArtisans: true

  set: (key, val, options) ->
    if _.isObject key
      [attrs, options] = [key, val]
    else
      (attrs = {})[key] = val
    if 'code' of attrs and not ('js' of attrs)
      attrs.js = @compile attrs.code
    super attrs, options

  onLoaded: ->
    super()
    @set 'js', @compile(@get 'code') unless @get 'js'

  compile: (code) ->
    return code if @get('codeLanguage') and @get('codeLanguage') is 'javascript'
    if @get('codeLanguage') and @get('codeLanguage') isnt 'coffeescript'
      return console.error('Can\'t compile', @get('codeLanguage'), '-- only CoffeeScript/JavaScript.', @)
    try
      js = CoffeeScript.compile(code, bare: true)
    catch e
      #console.log 'couldn\'t compile', code, 'for', @get('name'), 'because', e
      js = @get 'js'
    js

  getDependencies: (allComponents) ->
    results = []
    for dep in @get('dependencies') or []
      comp = _.find allComponents, (c) ->
        c.get('original') is dep.original and c.get('version').major is dep.majorVersion
      for result in comp.getDependencies(allComponents).concat [comp]
        results.push result unless result in results
    results
