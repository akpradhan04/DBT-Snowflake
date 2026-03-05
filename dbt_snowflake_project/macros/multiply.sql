{% macro multiply(
        multiplicand,
        multiplier,
        precision
    ) %}
    ROUND(
        {{ multiplicand }} * {{ multiplier }},
        {{ precision }}
    )
{% endmacro %}
