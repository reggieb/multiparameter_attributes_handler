module MultiparameterAttributesHandler
  VERSION = "0.0.3"
end

# History
# =======
# 
# 0.0.3: Allowed a block to be user to modify the output
# ------------------------------------------------------
# A use case was found where the resulting data needed to be stored as a 
# string, rather than a date. As there may be other ways the output needs
# modifying, this functionality was added by allowing a block to be
# passed to manipulate_all.
# 
# 0.0.2: Modified usage so that developer decides where manipulation happens
# ---------------------------------------------------------------------------
# 
# Previously, it was assumed that the functionality would be applied to a model's
# attributes= method, as this is where most params values are sent (eventually).
# 
# After some experimentation and consideration, it was realised that this is
# too restrictive. It also became apparent that the manipulation may need to 
# happen in the controller rather than the model. Especially in Rails 4 where
# strong_parameters will already be manipulating the params.
# 
# Therefore, the functionality was repackaged so it could be used anywhere. 
# 
# This change in usage will also make it easier to create single method usage
# in the future: where rather than manipulating all multiparameter attributes,
# it will be possible to specify which attributes to manipulate.
# 
# 0.0.1: First gem
# ----------------
# 
# Released for testing and review of functionality.
# 

