defmodule MontrexWeb.MontrexHome do

  use Phoenix.LiveView

  def mount(_params, _session, socket) do

    time = Calendar.strftime(NaiveDateTime.utc_now(), "%I:%M:%S")
    selected_screen = 1
    training_time = Time.new!(0,0,0,0)
    socket = assign(socket, training_time: training_time)
    socket = assign(socket, time: time)
    socket = socket |>
      assign(selected_screen: selected_screen)

    socket = socket |>
      assign(heart: 99)


    socket = assign(socket, start: nil)
    if connected?(socket), do: send(self(), "tick")
    if connected?(socket), do: send(self(), "heart_beat")

    {:ok, socket}
  end


  def handle_event("tick", _value, socket) do
    time = Calendar.strftime(NaiveDateTime.utc_now(), "%I:%M:%S")
    socket = assign(socket, time: time)
    send(self(), "tick")
    {:noreply, socket}
  end
  def handle_event("heart_beat", _value, socket) do
    heart = Enum.random(99..110)
    socket = assign(socket, heart: heart)
    send(self(), "heart_beat")
    {:noreply, socket}
  end
  def handle_event("down", _value, socket) do

      if socket.assigns.selected_screen == 11 do

        socket = assign(socket, selected_screen: 1)
        {:noreply, socket}

      else
        selected_screen = socket.assigns.selected_screen + 1
        socket = socket |>
        assign(selected_screen: selected_screen)
        {:noreply, socket}

      end



  end
  def handle_event("up", _value, socket) do
    selected_screen = socket.assigns.selected_screen - 1
    socket = socket |>
      assign(selected_screen: selected_screen)
    {:noreply, socket}
  end
  def handle_event("start", _value, socket) do
    IO.inspect("Start event has been reached")


    cond do
      socket.assigns.start == true ->
        socket = assign(socket, selected_screen: 10)
        send(self(), "start")
        {:noreply, socket}

      socket.assigns.start == false ->
        socket = assign(socket, training_time: Time.new!(0,0,0,0))
        {:noreply, socket}
      socket.assigns.start == nil ->
        socket = assign(socket, start: true)
        send(self(), "start")
        {:noreply, socket}

    end

  end

  def handle_event("end", _value, socket) do
    socket = assign(socket, start: nil)
    socket = assign(socket, training_time: Time.new!(0,0,0,0))
    socket = assign(socket, selected_screen: 11)

    {:noreply, socket}
  end

  def handle_info("start", socket) do
    if socket.assigns.start == true do
      add = Time.add(socket.assigns.training_time, 2000, :millisecond)
      socket = assign(socket, training_time: add)
      :timer.send_after(2000, self(), "start")
      {:noreply, socket}
    else
      {:noreply, socket}

    end

  end

  def handle_info("heart_beat", socket) do
    heart = Enum.random(99..110)
    socket = assign(socket, heart: heart)
    :timer.send_after(5000, self(), "heart_beat")
    {:noreply, socket}
  end


  def handle_info("tick", socket) do
    time = Calendar.strftime(NaiveDateTime.utc_now(), "%I:%M:%S")
    socket = assign(socket, time: time)
    :timer.send_after(1000, self(), "tick")
    {:noreply, socket}
  end



  def render(assigns) do
    ~H"""
    <div>
      <button phx-click="up">Up</button>
      <button phx-click="down">Down</button>
      <button phx-click="start">Start</button>
      <button phx-click="end"></button>
    </div>
    <%= inspect(@selected_screen) %>
    <!-- Screen 1 -->
    <%= if @selected_screen >0 and @selected_screen < 2 do %>
      <div class="WatchContainer">
        <div class="WatchContainer__Element"><%= Calendar.strftime(DateTime.utc_now(), "%d/%m") %> </div>
        <div class="WatchContainer__Element WatchContainer__Element__Central"><%= @time %></div>
        <div class="WatchContainer__Element">
            <span>56%<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-battery-full" viewBox="0 0 16 16"><path d="M2 6h10v4H2V6z"/><path d="M2 4a2 2 0 0 0-2 2v4a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V6a2 2 0 0 0-2-2H2zm10 1a1 1 0 0 1 1 1v4a1 1 0 0 1-1 1H2a1 1 0 0 1-1-1V6a1 1 0 0 1 1-1h10zm4 3a1.5 1.5 0 0 1-1.5 1.5v-3A1.5 1.5 0 0 1 16 8z"/></svg></span>
            <span>56%<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-person" viewBox="0 0 16 16"><path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6Zm2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0Zm4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4Zm-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 1.664h10Z"/></svg></span>
            <span><%= @heart %><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-activity" viewBox="0 0 16 16"><path fill-rule="evenodd" d="M6 2a.5.5 0 0 1 .47.33L10 12.036l1.53-4.208A.5.5 0 0 1 12 7.5h3.5a.5.5 0 0 1 0 1h-3.15l-1.88 5.17a.5.5 0 0 1-.94 0L6 3.964 4.47 8.171A.5.5 0 0 1 4 8.5H.5a.5.5 0 0 1 0-1h3.15l1.88-5.17A.5.5 0 0 1 6 2Z"/></svg></span>
        </div>
      </div>
      <% end %>
      <!-- Screnn 2 -->
      <%= if @selected_screen >= 2 and @selected_screen < 3  do %>
        <div class="WatchContainer">
          <div class="WatchContainer__Element WatchContainer__Element__Health">
              <span class="Watch__Container__Data"><span><%= @heart %></span><svg class="Watch__Container__Icon" xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-activity" viewBox="0 0 16 16"><path fill-rule="evenodd" d="M6 2a.5.5 0 0 1 .47.33L10 12.036l1.53-4.208A.5.5 0 0 1 12 7.5h3.5a.5.5 0 0 1 0 1h-3.15l-1.88 5.17a.5.5 0 0 1-.94 0L6 3.964 4.47 8.171A.5.5 0 0 1 4 8.5H.5a.5.5 0 0 1 0-1h3.15l1.88-5.17A.5.5 0 0 1 6 2Z"/></svg></span>
          </div>
          <div class="WatchContainer__Element WatchContainer__Element__Health">
              <span class="Watch__Container__Data"><span>56</span><svg class="Watch__Container__Icon" xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-lightning-fill" viewBox="0 0 16 16"><path d="M5.52.359A.5.5 0 0 1 6 0h4a.5.5 0 0 1 .474.658L8.694 6H12.5a.5.5 0 0 1 .395.807l-7 9a.5.5 0 0 1-.873-.454L6.823 9.5H3.5a.5.5 0 0 1-.48-.641l2.5-8.5z"/></svg>
          </span>
          </div>
          <div class="WatchContainer__Element WatchContainer__Element__Health">
              <span class="Watch__Container__Data"><span>75/100</span><svg class="Watch__Container__Icon" xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-person" viewBox="0 0 16 16"><path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6Zm2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0Zm4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4Zm-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 1.664h10Z"/></svg></span>
          </div>
        </div>
      <% end %>
      <!-- Screen 3 -->

      <%= if @selected_screen >= 3 and @selected_screen < 4 do %>

      <div class="WatchContainer">
        <div class="WatchContainer__Element WatchContainer__Element__Settings WatchContainer__Element__Selected">
            Trainings
        </div>
        <div class="WatchContainer__Element WatchContainer__Element__Settings">
            GPS
        </div>
        <div class="WatchContainer__Element WatchContainer__Element__Settings">
            Bluethooth
        </div>
      </div>

      <% end %>

      <%= if @selected_screen >= 4  and @selected_screen < 5 do %>

      <div class="WatchContainer">
        <div class="WatchContainer__Element WatchContainer__Element__Settings">
            Trainings
        </div>
        <div class="WatchContainer__Element WatchContainer__Element__Settings WatchContainer__Element__Selected">
            GPS
        </div>
        <div class="WatchContainer__Element WatchContainer__Element__Settings">
            Bluethooth
        </div>
      </div>

      <% end %>


      <%= if @selected_screen >= 5 and @selected_screen < 6 do %>

      <div class="WatchContainer">
        <div class="WatchContainer__Element WatchContainer__Element__Settings">
            Trainings
        </div>
        <div class="WatchContainer__Element WatchContainer__Element__Settings ">
            GPS
        </div>
        <div class="WatchContainer__Element WatchContainer__Element__Settings WatchContainer__Element__Selected">
            Bluethooth
        </div>
      </div>
      <% end %>

      <!-- Screen 4 -->
      <%= if @selected_screen > 9 and @selected_screen <= 10 do %>

      <div class="WatchContainer">
        <div class="WatchContainer__Element">
              <span>56%<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-battery-full" viewBox="0 0 16 16"><path d="M2 6h10v4H2V6z"/><path d="M2 4a2 2 0 0 0-2 2v4a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V6a2 2 0 0 0-2-2H2zm10 1a1 1 0 0 1 1 1v4a1 1 0 0 1-1 1H2a1 1 0 0 1-1-1V6a1 1 0 0 1 1-1h10zm4 3a1.5 1.5 0 0 1-1.5 1.5v-3A1.5 1.5 0 0 1 16 8z"/></svg></span>
              <span><%= Calendar.strftime(DateTime.utc_now(), "%d/%m") %><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-calendar-week" viewBox="0 0 16 16"><path d="M11 6.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1zm-3 0a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1zm-5 3a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1zm3 0a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1z"/><path d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5zM1 4v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V4H1z"/></svg></span>
          </div>
          <div class="WatchContainer__Element WatchContainer__Element__Central"><%= Calendar.strftime(@training_time, "%H:%M:%S") %></div>
          <div class="WatchContainer__Element WatchContainer__Element__HeartRate"><span><%= @heart %><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-activity" viewBox="0 0 16 16"><path fill-rule="evenodd" d="M6 2a.5.5 0 0 1 .47.33L10 12.036l1.53-4.208A.5.5 0 0 1 12 7.5h3.5a.5.5 0 0 1 0 1h-3.15l-1.88 5.17a.5.5 0 0 1-.94 0L6 3.964 4.47 8.171A.5.5 0 0 1 4 8.5H.5a.5.5 0 0 1 0-1h3.15l1.88-5.17A.5.5 0 0 1 6 2Z"/></svg></span>
          </div>
        </div>
      <% end %>


      <%= if @selected_screen > 10 and @selected_screen <= 11 do %>
      <div class="WatchContainer">
        <div class="WatchContainer__Element WatchContainer__Element__Central">Continue</div>
        <div class="WatchContainer__Element WatchContainer__Element__Central" style="color: red;">End</div>
      </div>
      <% end %>
    """
  end

end
