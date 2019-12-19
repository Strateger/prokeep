defmodule Genq do
  use GenServer

  def start_link(queue) do
    name = via_tuple(queue)

    GenServer.start(
      __MODULE__,
      :queue.new(),
      name: name
    )
  end

  defp via_tuple(queue) do
    {:via, Registry, {Registry.MessageQueue, queue}}
  end

  def add_message_to_queue(queue, message) do
    name = via_tuple(queue)

    GenServer.cast(name, {:add_message, message})
  end

  def get_queue(queue) do
    name = via_tuple(queue)

    GenServer.call(name, {:get_queue})
  end

  # @impl true
  def init(state) do
    ###  this lets us call :time_out and terminate.  It will now terminate gracefully
    schedule_message_process()
    {:ok, state}
  end

  def handle_info(:process_a_message, state) do
    newQ =
      case :queue.out(state) do
        {{:value, message}, newQueue} ->
          IO.inspect("processing message: " <> message)
          newQueue

        {:empty, emptyQueue} ->
          emptyQueue
      end

    schedule_message_process()
    {:noreply, newQ}
  end

  def handle_cast({:add_message, message}, state) do
    IO.inspect("ADDED A MESSAGE ---------------------------")
    {:noreply, :queue.in(message, state)}
  end

  def handle_call({:get_queue}, _from, state) do
    {:reply, state, state}
  end

  defp schedule_message_process do
    Process.send_after(self(), :process_a_message, 1000)
  end
end
