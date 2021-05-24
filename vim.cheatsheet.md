## Vim Cheat Sheet

### Edit a Selection
  Visual highlight the lines you want with shift+v
  then type : to get :'<,'>

  Examples:

    Delete Trailing Whitespace from Selection
      :'<,'>s/\s\+$

    Delete Leading Whitespace from Selection
      :'<,'>le
    
    Add Something to the End of a Selection:
      :'<,'>s/$/whateveryouwant/
