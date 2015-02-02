#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <stdint.h>

value cairo_address(value v)
{
    return caml_copy_nativeint(*(intptr_t *)Data_custom_val(v));
}
