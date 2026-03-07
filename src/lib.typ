#import "../requirements.typ":*
#import "layout/spring-fruchterman-reingold.typ":spring-fruchterman-reingold

#let render-graph = (positions, W, H, adjacency-matrix) => cetz.canvas(
  {
    import cetz.draw: *

    line((-.5,-.5), (W+.5, -.5))
    line((W+.5,-.5), (W+.5, H+.5))
    line((W+.5, H+.5),(-.5, H+.5))
    line((-.5, H+.5),(-.5, -.5))

    // Your drawing code goes here
    for row in range(adjacency-matrix.len()) {
      for col in range(adjacency-matrix.len()) {
        line(positions.at(row), positions.at(col), stroke: (blue+1.5pt))
      }
    }

    for node in positions{
      circle(node, radius:.4, fill: green)
    }
  }
)

#let graph-diagram = (
  adjacency-matrix,
  W:10,
  H:10,
  random-seed: 42,
  layout-fun : (random-positions, W, H, adjacency-matrix) => array,
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

  

  render-graph(random-positions, W, H, adjacency-matrix)

  pagebreak()

  let positions = layout-fun(random-positions, H, W, adjacency-matrix)

  render-graph(positions, W, H, adjacency-matrix)
}
