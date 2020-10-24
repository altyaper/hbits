// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../styles/app.scss"
import socket from "./socket"

import "phoenix_html"
import "jquery"
import "bootstrap"
import "pretty-dropdowns"

$(document).ready(function() {
    $('.nice-select').prettyDropdown({
        width: "100%"
    });
});