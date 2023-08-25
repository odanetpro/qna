export function simpleFormat(str) {
  str = str.replace(/\r\n?/, "\n").trim()

  if (str.length > 0) {
    str = str.replace(/\n\n+/g, '</p><p>')
    str = str.replace(/\n/g, '<br />')
    str = '<p>' + str + '</p>'
  }

  return str
}
