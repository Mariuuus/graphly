#let spring-fruchterman-reingold-inner = (
    random-positions,
    W, 
    H,
    adjacency-matrix,
    iterations, 
    cool :  (iterations:int) => int, 
  ) => {
    let N = adjacency-matrix.len()
    let positions = random-positions

    let temperature = cool(iterations, 1, W)
    let area = W*H
    let k = calc.sqrt(area/(N))

    let repulsive-force = x => (k * k)/x
    let attractive-force = x => (x * x)/k

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

      temperature = cool(iterations, i+1, W)

    }
    positions
} 

#let spring-fruchterman-reingold = (
  iterations:100, 
  cool : (iterations, iteration, W) => (((iterations - iteration)/iterations) * (1/10 * W))
) => (
    random-positions, 
    W, 
    H, 
    adjacency-matrix
  ) => spring-fruchterman-reingold-inner(
    random-positions,
    W,
    H,
    adjacency-matrix,
    iterations, 
    cool: cool,
)

