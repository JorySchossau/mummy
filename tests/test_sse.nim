## Tests for Server-Sent Events (SSE) implementation

import ../src/mummy {.all.}, ../src/mummy/internal, std/options, std/nativesockets

block:
  # Simple data event
  let event = SSEEvent(data: "Hello")
  doAssert formatSSEEvent(event) == "data: Hello\n\n"

block:
  # Event with type
  let event = SSEEvent(event: some("message"), data: "Hi")
  doAssert formatSSEEvent(event) == "event: message\ndata: Hi\n\n"

block:
  # Event with id
  let event = SSEEvent(id: some("123"), data: "Test")
  doAssert formatSSEEvent(event) == "id: 123\ndata: Test\n\n"

block:
  # Event with retry
  let event = SSEEvent(retry: some(5000), data: "Test")
  doAssert formatSSEEvent(event) == "retry: 5000\ndata: Test\n\n"

block:
  # Multiline data
  let event = SSEEvent(data: "Line 1\nLine 2")
  doAssert formatSSEEvent(event) == "data: Line 1\ndata: Line 2\n\n"

block:
  # Multiline data with trailing newline
  let event = SSEEvent(data: "Line 1\nLine 2\n")
  doAssert formatSSEEvent(event) == "data: Line 1\ndata: Line 2\n\n"

block:
  # All fields present
  let event = SSEEvent(
    event: some("update"),
    data: "test",
    id: some("123"),
    retry: some(5000)
  )
  let expected = "event: update\nid: 123\nretry: 5000\ndata: test\n\n"
  doAssert formatSSEEvent(event) == expected

block:
  # Empty data
  let event = SSEEvent(data: "")
  doAssert formatSSEEvent(event) == "\n"

block:
  # SSEEvent default values
  let event = SSEEvent()
  doAssert event.event.isNone == true
  doAssert event.id.isNone == true
  doAssert event.retry.isNone == true
  doAssert event.data == ""

block:
  # Simple data event
  let event = SSERawEvent(data: "data: Hello")
  doAssert formatSSEEvent(event) == "data: Hello\n\n"

block:
  # Event with type
  let event = SSERawEvent(event: some("message"), data: "data: Hi")
  doAssert formatSSEEvent(event) == "event: message\ndata: Hi\n\n"

block:
  # Event with id
  let event = SSERawEvent(id: some("123"), data: "data: Test")
  doAssert formatSSEEvent(event) == "id: 123\ndata: Test\n\n"

block:
  # Event with retry
  let event = SSERawEvent(retry: some(5000), data: "data: Test")
  doAssert formatSSEEvent(event) == "retry: 5000\ndata: Test\n\n"

block:
  # Multiline data
  let event = SSERawEvent(data: "data: Line 1\ndata: Line 2")
  doAssert formatSSEEvent(event) == "data: Line 1\ndata: Line 2\n\n"

block:
  # Multiline data with trailing newline
  let event = SSERawEvent(data: "data: Line 1\ndata: Line 2\n")
  doAssert formatSSEEvent(event) == "data: Line 1\ndata: Line 2\n\n"

block:
  # All fields present
  let event = SSERawEvent(
    event: some("update"),
    data: "data: test",
    id: some("123"),
    retry: some(5000)
  )
  let expected = "event: update\nid: 123\nretry: 5000\ndata: test\n\n"
  doAssert formatSSEEvent(event) == expected

block:
  # Empty data
  let event = SSEEvent(data: "")
  doAssert formatSSEEvent(event) == "\n"


block:
  # SSEConnection fields exist
  # This just verifies the type compiles correctly
  discard SSEConnection(
    server: nil,
    clientSocket: 0.SocketHandle,
    clientId: 0,
    active: false
  )
