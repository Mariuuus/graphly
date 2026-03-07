#import "../requirements.typ":*
#import "layout/spring-fruchterman-reingold.typ":spring-fruchterman-reingold

#let render-graph = (
  positions, 
  W, 
  H, 
  adjacency-matrix,
  node-style,
  edge-style
) => cetz.canvas(
  {
    import cetz.draw: *

    line((-.5,-.5), (W+.5, -.5))
    line((W+.5,-.5), (W+.5, H+.5))
    line((W+.5, H+.5),(-.5, H+.5))
    line((-.5, H+.5),(-.5, -.5))
    

    set-style(..edge-style)
    // Your drawing code goes here
    for row in range(adjacency-matrix.len()) {
      for col in range(adjacency-matrix.len()) {
        if(adjacency-matrix.at(row).at(col) == 1) {
          line(positions.at(row), positions.at(col))
        }
      }
    }
    set-style(..node-style)
    for node in positions{
      circle(node)
    }
  }
)

#let graph-diagram = (
  adjacency-matrix,
  W:10,
  H:10,
  random-seed: 42,
  layout-fun : (random-positions, W, H, adjacency-matrix) => array,
  node-style: (stroke: black, fill:yellow.lighten(80%), radius: .5),
  edge-style: (stroke: gray)
) => {
  assert(
    adjacency-matrix.all(it => it.len() == adjacency-matrix.len()), 
    message: "`adjacency-matrix` must be squared!"
  )

  let N = adjacency-matrix.len()

  let rng = gen-rng-f(random-seed)
  let random-positions = ()
  for i in range(adjacency-matrix.len()) {
    let random-position = ()
    (rng, random-position) = random-f(rng, size: 2)
    random-positions.push((random-position.at(0) * W, random-position.at(1) * H))
  }

  //render-graph(random-positions, W, H, adjacency-matrix, node-style, edge-style)
  //pagebreak()

  let (positions, end-iteration) = layout-fun(random-positions, H, W, adjacency-matrix)

  [#end-iteration]

  render-graph(positions, W, H, adjacency-matrix, node-style, edge-style)
}
