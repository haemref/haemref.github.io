module Example exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)


suite : Test
suite =
    describe "What is under test"
        [ test "1+1=2" <|
            \() ->
                Expect.equal 2 (1 + 1)
        ]
