#import "../src/lib.typ": graph-diagram, spring-fruchterman-reingold

#set page(height: auto, width: auto)

#graph-diagram(
  (
    (0,0,1,0),
    (0,0,1,1),
    (1,1,1,1),
    (0,1,1,0)
  ),
  layout-fun: spring-fruchterman-reingold(
    iterations: 200
  ),
  random-seed: 20
)