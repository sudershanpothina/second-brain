$var1 = 1

if ($var1 -eq 2) 
{
    "If block"
}
elseif ($var1 -eq 3) {
    "else if block"
}
else 
{
    "Else block"
}

# switch, can match multiple conditions

switch ($var1)
{
    41 {"var 1 equals to 41"}
    61 {"var 1 equals to 61"}
    "41" {"var 1 equals to 41"}
    default {"default"}
}

#add break to stop processing after first match

switch ($var1)
{
    41 {"var 1 equals to 41"; break}
    61 {"var 1 equals to 61"; break}
    "41" {"var 1 equals to 41"; break}
    default {"default"}
}

#switch for collections

switch (3,2,1,4)
{
    3 {"Three"}
    2 {"Two"}
    default {"dono"}
}

# switch supports wildcard and case sensitivity

switch -Wildcard ("TestWildCard")
{
    "test*" {"wild card"}
    "?est*" {"first char wild and last few wild"}
    default {"default"}
}
