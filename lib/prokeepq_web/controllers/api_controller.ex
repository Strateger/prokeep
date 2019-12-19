defmodule ProkeepqWeb.ApiController do
  use ProkeepqWeb, :controller

  def receiveMessage(conn, %{"queue" => queue, "message" => message}) do
    # IO.inspect(queue)
    # IO.inspect(message)

    if Registry.lookup(Registry.MessageQueue, queue) == [] do
      Genq.start_link(queue)
    end

    Genq.add_message_to_queue(queue, message)

    conn
    |> put_status(200)
    |> json("")
  end
end
