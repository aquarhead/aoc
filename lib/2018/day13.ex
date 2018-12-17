defmodule AoC.Year2018.Day13 do
  defmodule Cart do
    defstruct [:pos, :direction, :choice]

    def move(cart) do
      {x, y} = cart.pos

      new_pos =
        case cart.direction do
          ?^ -> {x, y - 1}
          ?v -> {x, y + 1}
          ?< -> {x - 1, y}
          ?> -> {x + 1, y}
        end

      %__MODULE__{
        cart
        | pos: new_pos
      }
    end

    def turn(cart, track) do
      cond do
        track in '|-' ->
          cart

        track in '\\/' ->
          %__MODULE__{
            cart
            | direction: track_turn(cart.direction, track)
          }

        track == ?+ ->
          %__MODULE__{
            cart
            | direction: cross_turn(cart.direction, cart.choice),
              choice: next_choice(cart.choice)
          }

        true ->
          raise "wtf?? track is #{Kernel.inspect(track)}"
      end
    end

    defp track_turn(?^, ?\\), do: ?<
    defp track_turn(?^, ?/), do: ?>
    defp track_turn(?v, ?\\), do: ?>
    defp track_turn(?v, ?/), do: ?<

    defp track_turn(?<, ?\\), do: ?^
    defp track_turn(?<, ?/), do: ?v
    defp track_turn(?>, ?\\), do: ?v
    defp track_turn(?>, ?/), do: ?^

    defp cross_turn(?^, :left), do: ?<
    defp cross_turn(?^, :right), do: ?>

    defp cross_turn(?v, :left), do: ?>
    defp cross_turn(?v, :right), do: ?<

    defp cross_turn(?<, :left), do: ?v
    defp cross_turn(?<, :right), do: ?^

    defp cross_turn(?>, :left), do: ?^
    defp cross_turn(?>, :right), do: ?v

    defp cross_turn(direction, :straight), do: direction

    defp next_choice(:left), do: :straight
    defp next_choice(:straight), do: :right
    defp next_choice(:right), do: :left
  end

  def crash(input) do
    {tracks, carts} = read_input(input)

    Stream.repeatedly(fn -> nil end)
    |> Enum.reduce_while(
      carts,
      fn _, in_carts ->
        new_carts =
          in_carts
          # sort the carts
          |> Enum.sort_by(
            fn cart -> cart.pos end,
            fn {x1, y1}, {x2, y2} ->
              y1 < y2 || (y1 == y2 && x1 <= x2)
            end
          )
          # run a tick
          |> tick_carts(tracks)

        case new_carts do
          {:collision, pos} -> {:halt, pos}
          new_carts -> {:cont, new_carts}
        end
      end
    )
  end

  defp read_input(input) do
    {_, tracks, carts} =
      input
      |> String.split("\n", trim: true)
      |> Enum.reduce(
        {0, %{}, []},
        fn line, {y, tracks_acc_y, carts_acc_y} ->
          {_, new_tracks, new_carts} =
            line
            |> String.to_charlist()
            |> Enum.reduce(
              {0, tracks_acc_y, carts_acc_y},
              fn char, {x, tracks_acc, carts_acc} ->
                {t, c} =
                  case parse_input(char) do
                    {nil, nil} ->
                      {tracks_acc, carts_acc}

                    {nil, track} ->
                      {Map.put(tracks_acc, {x, y}, track), carts_acc}

                    {cart, track} ->
                      {
                        Map.put(tracks_acc, {x, y}, track),
                        [
                          %Cart{cart | pos: {x, y}}
                          | carts_acc
                        ]
                      }
                  end

                {x + 1, t, c}
              end
            )

          {y + 1, new_tracks, new_carts}
        end
      )

    {tracks, carts}
  end

  # whitespace: no cart, no track
  defp parse_input(?\s), do: {nil, nil}
  defp parse_input(?\n), do: {nil, nil}

  # cart and track
  defp parse_input(cart_direction) when cart_direction in '^v<>' do
    cart = %Cart{
      direction: cart_direction,
      choice: :left
    }

    track =
      if cart_direction in '^v' do
        ?|
      else
        ?-
      end

    {cart, track}
  end

  # only track, without cart
  defp parse_input(track), do: {nil, track}

  defp tick_carts(carts, tracks), do: do_tick_carts([], carts, tracks)

  defp do_tick_carts(ticked_carts, [], _), do: ticked_carts

  defp do_tick_carts(ticked_carts, [cart | rest_carts], tracks) do
    moved_cart = Cart.move(cart)

    collide? =
      Enum.any?(ticked_carts, fn cart -> cart.pos == moved_cart.pos end) ||
        Enum.any?(rest_carts, fn cart -> cart.pos == moved_cart.pos end)

    if collide? do
      {:collision, moved_cart.pos}
    else
      turned_cart = Cart.turn(moved_cart, Map.get(tracks, moved_cart.pos))
      do_tick_carts([turned_cart | ticked_carts], rest_carts, tracks)
    end
  end

  def crash_until(input) do
    {tracks, carts} = read_input(input)

    Stream.repeatedly(fn -> nil end)
    |> Enum.reduce_while(
      carts,
      fn _, in_carts ->
        new_carts =
          in_carts
          # sort the carts
          |> Enum.sort_by(
            fn cart -> cart.pos end,
            fn {x1, y1}, {x2, y2} ->
              y1 < y2 || (y1 == y2 && x1 <= x2)
            end
          )
          # run a tick
          |> tick_carts_remove_crash(tracks)

        case new_carts do
          [final_cart] -> {:halt, final_cart.pos}
          new_carts -> {:cont, new_carts}
        end
      end
    )
  end

  defp tick_carts_remove_crash(carts, tracks), do: do_tcrc([], carts, tracks)

  defp do_tcrc(ticked_carts, [], _), do: ticked_carts

  defp do_tcrc(ticked_carts, [cart | rest_carts], tracks) do
    moved_cart = Cart.move(cart)

    tc_idx = Enum.find_index(ticked_carts, fn cart -> cart.pos == moved_cart.pos end)
    rc_idx = Enum.find_index(rest_carts, fn cart -> cart.pos == moved_cart.pos end)

    case {tc_idx, rc_idx} do
      {nil, nil} ->
        turned_cart = Cart.turn(moved_cart, Map.get(tracks, moved_cart.pos))
        do_tcrc([turned_cart | ticked_carts], rest_carts, tracks)

      {idx, nil} ->
        new_ticked_carts = List.delete_at(ticked_carts, idx)
        do_tcrc(new_ticked_carts, rest_carts, tracks)

      {nil, idx} ->
        new_rest_carts = List.delete_at(rest_carts, idx)
        do_tcrc(ticked_carts, new_rest_carts, tracks)
    end
  end
end
