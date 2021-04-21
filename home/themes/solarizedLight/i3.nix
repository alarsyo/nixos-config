let
  colors = import ./colors.nix;
in
with colors.i3;
{
  bar = {
    background = background;
    statusline = yellow;
    separator = red;

    focusedWorkspace = {
      border = aqua;
      background = aqua;
      text = darkGray;
    };
    inactiveWorkspace = {
      border = darkGray;
      background = darkGray;
      text = yellow;
    };
    activeWorkspace = {
      border = aqua;
      background = darkGray;
      text = yellow;
    };
    urgentWorkspace = {
      border = red;
      background = red;
      text = background;
    };
  };

  focused = {
    border = blue;
    background = blue;
    text = darkGray;
    indicator = purple;
    childBorder = darkGray;
  };

  focusedInactive = {
    border = darkGray;
    background = darkGray;
    text = yellow;
    indicator = purple;
    childBorder = darkGray;
  };

  unfocused = {
    border = darkGray;
    background = darkGray;
    text = yellow;
    indicator = purple;
    childBorder = darkGray;
  };

  urgent = {
    border = red;
    background = red;
    text = white;
    indicator = red;
    childBorder = red;
  };
}
