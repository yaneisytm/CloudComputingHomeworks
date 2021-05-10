provider "google" {
credentials = "${file("~/Yane/keysansibles.json")}"
project = "1064022129196"
region = "europe-west1"
zone = "europe-west1-b"
}
