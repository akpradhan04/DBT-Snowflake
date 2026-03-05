{% macro trim_upper(
        col_name,
        node
    ) %}
    {{ col_name | trim | upper }}
{% endmacro %}
