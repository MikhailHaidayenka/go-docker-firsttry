package main

import (
	"encoding/json"
	"errors"
	"fmt"
	"github.com/mather-economics/common-tools/connections"
	"github.com/mather-economics/common-tools/utils"
	"github.com/valyala/fasthttp"
	"os"
)

func main() {
	e := errors.New("tratata")
	utils.Check(e)

	k := connections.Consumer{}
	_ = k

	paths := func(ctx *fasthttp.RequestCtx) {
		switch string(ctx.Path()) {
		case "/test":
			res, _ := json.Marshal(struct {
				One string `json:"one"`
				Two string `json:"two"`
			}{
				One: os.Getenv("TEST_ARG"),
				Two: os.Getenv("TEST_ARG_1"),
			})
			ctx.SetBody(res)
			return
		default:
			ctx.Error("not found", fasthttp.StatusNotFound)
		}
	}

	fmt.Println("TEST ", "RUN")

	//port := os.Getenv("INGESTOR_PORT")
	if err := fasthttp.ListenAndServe(":"+"80", paths); err != nil {
		panic(err)
	}
}
