{% set min_nights_booked = 1 %}
{% set max_nights_booked = 5 %}
{% set flag = 0 %}
SELECT
    *
FROM
    {{ ref('bronze_bookings') }}

    {% if flag == 1 %}
    WHERE
        nights_booked = {{ min_nights_booked }}
    {% else %}
    WHERE
        nights_booked > {{ max_nights_booked }}
    {% endif %}
