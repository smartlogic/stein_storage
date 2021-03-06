defmodule Stein.Storage.S3Backend do
  @moduledoc """
  Backend for uploading to S3 buckets.

  See `Stein.Storage` for more information about configuration available.
  """

  alias ExAws.S3
  alias Stein.Storage.Temp

  @behaviour Stein.Storage

  @doc false
  def bucket(), do: Stein.Storage.config(Application.get_env(:stein_storage, :bucket))

  @impl true
  def delete(key) do
    bucket()
    |> S3.delete_object(key)
    |> ExAws.request()

    :ok
  end

  @impl true
  def download(key) do
    extname = Path.extname(key)
    {:ok, temp_path} = Temp.create(extname: extname)

    bucket()
    |> S3.download_file(key, temp_path)
    |> ExAws.request()

    {:ok, temp_path}
  end

  @impl true
  def upload(file, key, opts) do
    bucket()
    |> S3.put_object(key, File.read!(file.path), meta(opts))
    |> ExAws.request!()

    :ok
  end

  defp meta(opts) do
    meta = Keyword.get(opts, :meta, [])

    case opts[:public] do
      true ->
        public_meta() ++ meta

      _ ->
        meta
    end
  end

  defp public_meta() do
    [
      {:cache_control, "public, max-age=31536000"},
      {:acl, :public_read}
    ]
  end

  @impl true
  def url(key, opts) do
    case Keyword.has_key?(opts, :signed) do
      true ->
        config = ExAws.Config.new(:s3)
        {:ok, url} = S3.presigned_url(config, :get, bucket(), key, opts[:signed])
        url

      false ->
        "https://s3.amazonaws.com/#{bucket()}#{key}"
    end
  end
end
