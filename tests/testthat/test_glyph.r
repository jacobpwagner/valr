context('glyph')

x <- tibble::tribble(
  ~chrom, ~start, ~end, ~name, ~score, ~strand,
  "chr1", 500,    1000, '.',   '.',     '+',
  "chr1", 1000,   1500, '.',   '.',     '-'
)

test_that('glyphs are rendered', {
  res <- bed_glyph(bed_merge(x))
  expect_is(res, 'ggplot')
})

test_that('glyph labels are applied', {
  res <- bed_glyph(bed_merge(x, id = n()), label = 'id')
  expect_equal(res$labels$label, 'id')
})
