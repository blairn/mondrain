grid = {
  padding: 10
  width: 1920
  height: 1080
  max_x: 12
  max_y: 8
}

grid.generateScale = () ->
  grid.scale_x = d3.scale.linear()
    .domain([0, grid.max_x])
    .range([grid.padding, grid.width - grid.padding])

  grid.scale_y = d3.scale.linear()
    .domain([0, grid.max_y])
    .range([grid.padding, grid.height - grid.padding])


# this is normally called with item.grid to create item.location
grid.generateLocation = (d) ->
  x: grid.scale_x(d.x)
  y: grid.scale_y(d.y)
  width: grid.scale_x(d.width) - grid.padding * 2
  height: grid.scale_y(d.height) - grid.padding * 2

grid.generateRoundedInverse = (d) -> 
  x: Math.min(Math.max(Math.round(grid.scale_x.invert(d.x)), 0), grid.max_x)
  y: Math.min(Math.max(Math.round(grid.scale_y.invert(d.y)), 0), grid.max_y)
  width: Math.max(Math.round(grid.scale_x.invert(d.width + grid.padding * 2)),1)
  height: Math.max(Math.round(grid.scale_y.invert(d.height + grid.padding * 2)),1)
    
grid.snapLocation = (d) ->
  grid.generateLocation(grid.generateRoundedInverse(d))
    
grid.generateScale()

root = this ? exports
root.grid = grid
