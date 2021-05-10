resource "google_sql_database_instance" "terraform" {
name = "databasev1"
database_version = "MYSQL_5_7"
region = "europe-west1"
settings {
tier = "db-n1-standard-2"
}
}
resource "google_sql_database" "dbterraform" {
name = "dbterraform"
instance = "${google_sql_database_instance.terraform.name}"
charset = "utf8"
collation = "utf8_general_ci"
}
resource "google_sql_user" "usert" {
name = "yane"
instance = "${google_sql_database_instance.terraform.name}"
host = "%"
password = "admin"
}
