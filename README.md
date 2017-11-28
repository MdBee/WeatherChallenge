# WeatherChallenge
This is a quick effort to satisfy the requirements of the Weather Coding Challenge exercise.

Given more time I would refactor to take advantage of Swift 4's Codable protocol and integrate it with a simpler and more up to date Core Data implementation.

My approach to caching the images is somewhat crude.  It works, but using a framework like Kingfisher might be better.  I wanted to avoid all third party dependencies (Cocoapods) for this demo.

I've lightened the SearchTableViewController by moving the logic and datasource and delegate functionality to SearchViewModel but now that file is overloaded.  If I had time I would refactor this into a proper view model and have more of the tableView's normal functionality in the table view controller class.

If it was desired and I had time to add detail to the comments I would use AppleScript syntax.

Test coverage is incomplete.

In case you're wondering:  The background colors represent temperature ranges.  The RefreshControl only refreshes the latest city.

Matt Bearson
