module Example.CounterStore where

import Control.Monad.Eff (Eff)
import OutWatch.Pure.Attributes (childShow, click, (<==), (==>))
import OutWatch.Pure.Render (render)
import OutWatch.Dom.Emitters (mapE)
import OutWatch.Dom.Types (VDom)
import OutWatch.Pure.Tags (button, div, h1, h3, text)
import OutWatch.Pure.Store (Store, createStore)
import Prelude (Unit, (+), (-), ($), const)
import Snabbdom (VDOM)

data Action
  = Increment
  | Decrement

type State = Int

initialState :: State
initialState = 11

update :: Action -> State -> State
update action state =
  case action of
    Increment -> state + 1
    Decrement -> state - 1

type AppStore eff = Store eff State Action

view :: forall eff. AppStore eff -> VDom eff
view store =
  div
    [ h1 [ text "counter-store example" ]
    , button
        [ text "Decrement"
        , mapE click (const Decrement) ==> store
        ]
    , button
        [ text "Increment"
        , mapE click (const Increment) ==> store
        ]
    , h3
        [ text "Counter: "
        , childShow <== store.src
        ]
    ]

main :: forall eff. Eff ( vdom :: VDOM | eff ) Unit
main =
  let
    store :: AppStore eff
    store = createStore initialState update in
  render "#app" $ view store
