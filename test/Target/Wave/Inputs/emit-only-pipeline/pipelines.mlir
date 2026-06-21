module attributes {transform.with_named_sequence} {
  transform.named_sequence @__transform_main(
      %root: !transform.any_op) -> !transform.any_op {
    transform.yield %root : !transform.any_op
  }
}
