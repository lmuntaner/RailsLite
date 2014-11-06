== RAILS LITE

This project replicates some of the magic of Rails.

We created a Base Controller class that replicates some of the functionality 
of ActionController::Base.

We built a Router that simulates the Rails routes. It creates a new controller
every time that is called and it invokes the action that needs to be invoked.
Then the action in the controller is the responsible for calling the method
for rendering the content that inherits from our own Controller Base.

We also created the classes for managing the cookies, just like rails does with
session, and managing the parameters coming from the body, the query and the
routes, just like rails does with params.

This specific project also creates the URLHelpers to set the paths in the
friendly manner "cats_url" or "cat_status_url(1, 1)".
This last part is in phase7 and it was a bonus for the project.