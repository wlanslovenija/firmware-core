#
# nodewatcher module
# EXAMPLE MODULE
#

# TODO More documentation on writing nodewatcher modules

# TODO We should also decide on and document MODULE_ID assignment

# Module metadata
MODULE_ID="example.test"
MODULE_SERIAL=1

#
# Report output function
#
report()
{
  show_entry "test.hello" "Hello world"
}

