color = d3.scale.category20();

setLocation = (selection) ->
  selection
    .style('left', (d) -> d.location.x + 'px')
    .style('top', (d) -> d.location.y + 'px')
    .style('width', (d) -> d.location.width + 'px')
    .style('height', (d) -> d.location.height + 'px')

move = (d) ->
  node = d3.select(this).node().parentNode
  d.location = d.location || grid.generateLocation(d.grid)
  d.location.x += d3.event.x
  d.location.y += d3.event.y
  el = d3.select(node).call(setLocation)
  snapLocation = {location: grid.snapLocation(d.location)}
  dropPanel = d3.select('.panels').selectAll('.dropPanel').data([snapLocation]).call(setLocation)
  dropPanel.style('visibility','visible')
  
resize = (d) ->  
  node = d3.select(this).node().parentNode
  d.location.width += d3.event.dx
  d.location.height += d3.event.dy
  el = d3.select(node).call(setLocation)
  snapLocation = {location: grid.snapLocation(d.location)}
  dropPanel = d3.select('.panels').selectAll('.dropPanel').data([snapLocation]).call(setLocation)
  dropPanel.style('visibility','visible')

snap = (d) ->    
  node = d3.select(this).node().parentNode
  d.grid = grid.generateRoundedInverse(d.location)
  d.location = grid.generateLocation(d.grid)
  el = d3.select(node).call(setLocation)
  dropPanel = d3.select('.panels').select('.dropPanel')
  dropPanel.style('visibility','hidden')

drag = d3.behavior.drag()
  .origin((d) -> 
    console.log(d)
    {x: 0, y:0}
  )
  .on('drag', move)
  .on('dragend', snap)

resize = d3.behavior.drag()
  .on('drag', resize)
  .on('dragend', snap)
  
panels_redraw = (data) ->
  dropPanel = d3.select('.panels').selectAll('.dropPanel').data([0])
    .enter()
      .append('div')
        .attr('class','dropPanel')
        .style('position','absolute')
        .style('background-color','hsl(0, 0%, 25%)')
        .style('visibility','hidden')
        
  panels = d3.select('.panels').selectAll('.panel').data(data)
  panels_enter(panels)
  panels_exit(panels)
  panels_update(panels)

panels_enter = (selection) ->
  div = selection.enter()
    .append('div')
    .attr('class','panel')
    .style('position','absolute')
    .style('background-color',(d) -> color(d.id))
  
  resize_box = div.append('div')
      .attr('class','resize')
      .style('position','absolute')
      .style('right',0)
      .style('bottom',0)
      .style('height','10px')
      .style('width','10px')
      .style('background-color','green')
      
  resize_box.call(resize)
  
  div.append('legend').call(drag)



panels_exit = (selection) ->
  selection.exit().remove()
  
  
panels_update = (selection) ->
  selection.select('legend').text((d) -> d.legend)
  selection.call(setLocation)

  
Template.dashboard.rendered = ->
  panels_config = [
      {id:0, legend:1, grid:{x:5, y:2, width:1, height:2}}
      {id:1, legend:2, grid:{x:6, y:2, width:2, height:1}}
      {id:2, legend:3, grid:{x:5, y:4, width:1, height:1}}
      {id:3, legend:4, grid:{x:6, y:3, width:2, height:2}}
  ]
  for p in panels_config
    p.location = grid.generateLocation(p.grid)  

  panels_redraw(panels_config)