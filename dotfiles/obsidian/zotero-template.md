{%- set frontmatter_fields = {
"title": '"' ~ (title | replace ('"','') or caseTitle | replace ('"','')) ~ '"',
"authors": '[' ~ authors | replace (";", ", ") ~ ']',
"editors": '[' ~ editors | replace (";", ", ") ~ ']',
"directors": '[' ~ directors | replace (";", ", ") ~ ']',
"podcasters": '[' ~ podcasters | replace (";", ", ") ~ ']',
"scriptwriters": '[' ~ scriptwriters | replace (";", ", ") ~ ']',
"year": date | format("YYYY"),
"date": date | format("YYYY-MM-DD"),
"citekey": citekey,
"type": type,
"class": itemType,
"url": url,
"isbn": ISBN
}
-%}

{# generate field safely -#}
{%- macro generateField(prefix, delimiter, f, p) -%}
{%- if p and p != "[undefined]"-%}
{{prefix}}{{f}}{{delimiter}}{{p}}
{% endif %}
{%- endmacro -%}

{#- generate fields based on Zotero properties -#}
{%- macro generateFields(prefix, delimiter, fields) -%}
{%- for field, property in fields -%}
{%- if property.length > 0 -%}
{{- generateField(prefix, delimiter, field, property) -}}
{%- endif -%}
{%- endfor -%}
{%- endmacro -%}

---
aliases: ["{{title | replace ('"','')}}"{%- if authors and date-%}, "
{%- for author in authors -%}
{{author}}
{%- endfor -%}
{{" ("+date | format("YYYY") +") "}}{{title | replace ('"','')}}{{caseTitle | replace ('"','')}}"{%- endif -%}]
{{generateFields("",": ",frontmatter_fields) -}}
---
# {{''~ (title | replace ('"','') or caseTitle | replace ('"','')) ~ ''}}
{% persist "notes" %}
{%- endpersist -%}
