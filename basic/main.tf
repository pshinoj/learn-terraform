resource "local_file" "my_file" {
  filename        = "my_file.txt"
  content         = "Hello World!"
  file_permission = "0765"
}
