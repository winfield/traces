App.Router = Backbone.Router.extend
  routes:
    ""  :  "index"
    "articles/new"  :  "newArticle" # put this before "articles/:slug", since the later will override this
    "articles/:slug"  :  "show"

  initialize: ->
    @session = new window.Session
    @session.fetch url: 'users/signed_in_check'
    @articlesCollection = new App.Collections.Articles
    @articlesView = new App.Views.Articles(el:$("body"), collection:@articlesCollection, session: @session)

  index: ->
    @articlesCollection.fetch(reset: true)
    document.title = "Traces"

  newArticle: ->
    new App.Views.NewArticle(collection: @articlesCollection)

  show: (slug) ->
    @articlesView.show(slug)
