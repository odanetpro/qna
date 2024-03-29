// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "bootstrap"
import "../stylesheets/application"
import "channels"
import "channels/questions"
import "channels/answers"
import "channels/comments"
import "utilities/answers"
import "utilities/questions"
import "utilities/show_gists"

require("jquery")
require("@nathanvda/cocoon")
require("underscore")
require("vendor/gh3")

import { simpleFormat } from "../utilities/simple_format"
window.simpleFormat = simpleFormat

Rails.start()
Turbolinks.start()
ActiveStorage.start()
