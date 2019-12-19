defmodule ProkeepqWeb.ApiControllerTest do
  use ProkeepqWeb.ConnCase

  test "GET /api/", %{conn: conn} do
    # conn = get(conn, "/api/receive-message/queue1/amessage")

    q1 = "queue1"
    q2 = "queue2"
    count = 6
    conn = fillQueue(q1, 6)
    :timer.sleep(100)
    conn = fillQueue(q2, 6)

    for n <- 1..count do
      :timer.sleep(1000)
      assert :queue.len(Genq.get_queue(q1)) == count - n
      assert :queue.len(Genq.get_queue(q2)) == count - n
    end

    assert json_response(conn, 200)
  end

  def fillQueue(queue, numberOfItemsToPutInQueue) do
    for n <- 1..(numberOfItemsToPutInQueue - 1),
        do: get(conn, "/api/receive-message/#{queue}/amessageInQueue:#{queue}")

    conn = get(conn, "/api/receive-message/#{queue}/amessageInQueue:#{queue}")
    conn
  end
end
