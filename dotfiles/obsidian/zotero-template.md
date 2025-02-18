{# Template modified from: github.com/nocona71/obsidian-literature-note #}

{%- set colorCategoryToMeaning = {
"yellow": "Relevant, Important",
"red": "Disagree",
"green": "Important to me",
"blue": "Question, Understanding, Vocabulary",
"purple": "Reference, Term to lookup later",
"pink": "pink - undefined",
"orange": "orange - undefined",
"gray": "gray - undefined"
}-%}

{# lookup Zotero colors in annotations with Category #}
{%- macro getMeaning(colorCategory) -%}
	{%- if colorCategory-%}
		{{- colorCategoryToMeaning[colorCategory] -}}
	{%- else -%}
		{{- colorCategoryToMeaning["yellow"] -}}
	{%- endif -%}
{%- endmacro -%}

{#- handle space characters in zotero tags -#}
{%- macro printTags(rawTags) -%}
	{%- if rawTags.length > 0 -%}
		{%- for tag in rawTags -%}
			#zotero/{{ tag.tag | lower | replace(" ","_") }} {{ ' ' }} 
		{%- endfor %}
	{%- endif %}
{%- endmacro -%}

{%- set frontmatter_fields = {
"title": '"' ~ (title | replace ('"','') or caseTitle | replace ('"','')) ~ '"',
"authors": '[' ~ authors | replace (";", ", ") ~ ']',
"editors": '[' ~ editors | replace (";", ", ") ~ ']',
"directors": '[' ~ directors | replace (";", ", ") ~ ']',
"podcasters": '[' ~ podcasters | replace (";", ", ") ~ ']',
"scriptwriters": '[' ~ scriptwriters | replace (";", ", ") ~ ']',
"online-uri": uri,
"year": date | format("YYYY"),
"date": date | format("YYYY-MM-DD"),
"citekey": citekey,
"pages": numPages,
"running-time": runningTime,
"type": type,
"class": itemType,
"language": language,
"url": url,
"isbn": ISBN,
"cover": "https://covers.openlibrary.org/b/isbn/"+ISBN | replace ("-","")+"-M.jpg"
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

{#- Generated subheadings -#}
{%- set categoryFields = [
"Summary",
"Goal",
"Method",
"Results",
"Future Work"
]
-%}

---
aliases: ["{{title | replace ('"','')}}"{%- if authors and date-%}, "
{%- for author in authors -%}
{{author}}
{%- endfor -%}
{{" ("+date | format("YYYY") +") "}}{{title | replace ('"','')}}{{caseTitle | replace ('"','')}}"{%- endif -%}]
{{generateFields("",": ",frontmatter_fields) -}}
---
{%- if ISBN -%}
![|200](https://covers.openlibrary.org/b/isbn/{{ISBN | replace ("-","")}}-M.jpg)
{%- endif -%}
{{printTags(tags)}}
# {{''~ (title | replace ('"','') or caseTitle | replace ('"','')) ~ ''}}
> [!info]- Abstract
> {{abstractNote}}
{% if relations.length > 0 -%}
> 
> > [!note]- References:  
> >
> > | title | proxy note | desktopURI |
> > | --- | --- | --- |
{%- for r in relations %}
> > | {{r.title | replace("|","❕")}} | [[@{{r.citekey}}]] | [Zotero Link]({{r.desktopURI}}) |
{%- endfor -%}
{{ "" }}
{%- endif %}
{% persist "notes" %}
{{ "" }}
{%- for cat in categoryFields -%}
{%- if isFirstImport -%}
## {{cat}}
{{ "" }}
{{ "" }}
{%- endif -%}
{%- endfor -%}
{%- endpersist -%}
{{ "" }}
{% persist "annotations" %} 
{%- set newAnnotations = annotations | filterby("date", "dateafter", lastImportDate) -%}
{% if newAnnotations.length > 0 %}
## Annotations
{% for annotation in newAnnotations %}
> [!annotation-{{ annotation.colorCategory | lower}}] {{getMeaning(annotation.colorCategory | lower)}}
> {%- if annotation.tags.length > 0 %} 
> {{printTags(annotation.tags)}}
{%- endif %}
{%- if annotation.annotatedText.length > 0 %} 
> 
> {{-annotation.annotatedText | nl2br -}} 
{%- endif %}
{%- if annotation.imageRelativePath %}
> ![[{{annotation.imageRelativePath}}|300]]
{%- endif %}
{%- if annotation.comment %} 
> 
> **comment:**
> {{annotation.comment | nl2br }}
{%- endif %}
> 
{%- if annotation.desktopURI %} 
> (see [PDF p. {{annotation.page}}]({{annotation.desktopURI}}))
{%- endif %}
{% endfor %}
{# {% endfor %} #}
{%- endif -%}
{%- endpersist -%}
