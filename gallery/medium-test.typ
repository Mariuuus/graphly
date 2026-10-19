#import "../src/lib.typ":*

//#set page(height: auto, width: auto)

#graph-diagram(
  W: 5,
  H: 5,
  (
    (0,1,1,1,0),
    (1,0,1,1,0),
    (1,1,0,1,1),
    (1,1,1,0,1),
    (0,0,1,1,1)
  ),
  layout-fun: spring-fruchterman-reingold(
    iterations: 100
  ),
  node-style: (
    fill: red,
    radius: 6pt,
    stroke: none
  ),
  edge-style: (
    stroke: black.transparentize(80%)
  )
)