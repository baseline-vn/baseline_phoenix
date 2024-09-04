defmodule BaselinePhoenix.Telegram do
  @base_url "https://api.telegram.org/bot#{Application.compile_env!(:baseline_phoenix, :telegram)[:bot_token]}"
  @dev_group_chat_id Application.compile_env!(:baseline_phoenix, :telegram)[:dev_group_chat_id]

  # TELEGRAM_BOT_TOKEN=7074710677:AAETNGxr4LlV2D9uyiQRXIpVIECx6a2G8n4
  # TELEGRAM_DEV_GROUP_CHAT_ID=-4590586218

  def send_otp(phone_number, otp) do
    message = "OTP for #{phone_number}: #{otp}"
    send_message(@dev_group_chat_id, message)
  end

  defp send_message(chat_id, text) do
    url = @base_url <> "/sendMessage"
    body = Jason.encode!(%{chat_id: chat_id, text: text})

    headers = [
      {"Content-Type", "application/json"}
    ]

    :post
    |> Finch.build(url, headers, body)
    |> Finch.request(BaselinePhoenix.Finch)
    |> handle_response()
  end

  defp handle_response({:ok, %Finch.Response{status: status, body: body}})
       when status in 200..299 do
    {:ok, Jason.decode!(body)}
  end

  defp handle_response({:ok, %Finch.Response{status: status, body: body}}) do
    {:error, "HTTP Status #{status}: #{body}"}
  end

  defp handle_response({:error, reason}) do
    {:error, "Request failed: #{inspect(reason)}"}
  end
end
