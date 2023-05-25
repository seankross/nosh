test_that("A response from the Notion Users API returns a data frame.", {
  test_response <- response(
    url = "https://api.notion.com/v1/users?page_size=100",
    headers = "Content-Type: application/json",
    body = list(has_more = FALSE,
                results = list(list(
                  name = "Sean",
                  id = "ABC123",
                  type = "person"))) |>
      toJSON(auto_unbox = TRUE) |>
      as.character() |>
      charToRaw()
  )

  result <- httr2::with_mock(\(x) test_response, users())
  expect_true(is.data.frame(result))
  expect_true(nrow(result) > 0)
})
