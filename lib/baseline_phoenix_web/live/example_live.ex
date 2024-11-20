defmodule BaselinePhoenixWeb.ExampleLive do
  use BaselinePhoenixWeb, :live_view

  def render(assigns) do
    ~H"""
    <div id="editor-container" phx-hook="TinyMDE">
      <div id="toolbar"></div>
      <textarea id="markdown-editor"></textarea>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    # Set initial content for the editor
    {:ok, assign(socket, :initial_content, "# Hello baseline")}
  end

  def handle_event("set_content", %{"content" => content}, socket) do
    # Handle the content from the editor (e.g., save to the database or handle updates)
    {:noreply, assign(socket, :content, content)}
  end
end
