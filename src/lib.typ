#import "../requirements.typ":*

#let graph-diagram = (
  adjacency-matrix,
  W:10,
  H:10,
) => {
  assert(
    adjacency-matrix.all(it => it.len() == adjacency-matrix.len()), 
    message: "`adjacency-matrix` must be squared!"
  )

  let N = adjacency-matrix.len()

  let rng = gen-rng-f(42)
  let random-positions = ()
  for i in range(adjacency-matrix.len()) {
    let random-position = ()
    (rng, random-position) = random-f(rng, size: 2)
    random-positions.push((random-position.at(0) * W, random-position.at(1) * H))
  }

  let positions = random-positions

  let render-graph = (positions) => cetz.canvas(
    {
    import cetz.draw: *

    line((0,0), (W, 0))
    line((W,0), (W, H))
    line((W, H),(0, H))
    line((0, H),(0, 0))

    // Your drawing code goes here
    for row in range(adjacency-matrix.len()) {
      for col in range(adjacency-matrix.len()) {
        line(positions.at(row), positions.at(col), stroke: (blue+1.5pt))
      }
    }

    for node in positions{
      circle(node, radius:.4, fill: green)
    }
  })

  render-graph(positions)

  pagebreak()


  // calculate spring layout using Fruchterman-Reingold
  let iterations = 100


  let temperature = 1/10 * W
  let area = W*H
  let k = calc.sqrt(area/(N))
  
  let repulsive-force = x => (k * k)/x
  let attractive-force = x => (x * x)/k
  let cool = (iteration) => (((iterations - iteration)/iterations) * (1/10 * W))

  for i in range(iterations) {
    let displacements = range(N).map(it => (0,0))

    for v in range(N){
      let displacement = (0,0)
      for u in range(N) {
        if(v!=u) {
          let diff = (positions.at(v).at(0) - positions.at(u).at(0), positions.at(v).at(1) - positions.at(u).at(1))
          let d = calc.sqrt(diff.at(0)*diff.at(0) + diff.at(1)*diff.at(1))

          if(diff.at(0) != 0) {
            displacement.at(0) += (diff.at(0)/d) * repulsive-force(d)
          }

          if(diff.at(1) != 0) {
            displacement.at(1) += (diff.at(1)/d) * repulsive-force(d)
          }
        }
      }
      displacements.at(v) = displacement
    }

    for v in range(adjacency-matrix.len()) {
      for u in range(adjacency-matrix.len()) {
        if(adjacency-matrix.at(v).at(u) == 1 and v < u) {
          let diff = (positions.at(v).at(0) - positions.at(u).at(0), positions.at(v).at(1) - positions.at(u).at(1))
          let d = calc.sqrt(diff.at(0)*diff.at(0) + diff.at(1)*diff.at(1))


          if(diff.at(0) != 0) {
            displacements.at(v).at(0) -= (diff.at(0)/d) * attractive-force(d)
            displacements.at(u).at(0) += (diff.at(0)/d) * attractive-force(d)
          }

          if(diff.at(1) != 0) {
            displacements.at(v).at(1) -= (diff.at(1)/d) * attractive-force(d)
            displacements.at(u).at(1) += (diff.at(1)/d) * attractive-force(d)
          }
        }
      }
    }
    //[#temperature\ ]

    for v in range(N){
      let d = calc.sqrt(displacements.at(v).at(0)*displacements.at(v).at(0) + displacements.at(v).at(1)*displacements.at(v).at(1))


      if(displacements.at(v).at(0) != 0) {
        positions.at(v).at(0) += (displacements.at(v).at(0)/d) * calc.min(d, temperature)
      }

      if(displacements.at(v).at(1) != 0) {
        positions.at(v).at(1) += (displacements.at(v).at(1)/d) * calc.min(d, temperature)
      }

      positions.at(v).at(0) = calc.min(W, calc.max(0, positions.at(v).at(0)))
      positions.at(v).at(1) = calc.min(H, calc.max(0, positions.at(v).at(1)))
    }

    temperature = cool(i+1)
  }

  render-graph(positions)
}