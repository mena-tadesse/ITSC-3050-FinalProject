Original App Design Project - README Template
===

# BOOK APP

## Table of Contents

1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Wireframes](#Wireframes)
4. [Schema](#Schema)

## Overview

### Description

An app where users can search/browse books (filtering system included), look at the book details (separate page), and favorite books (will have separate page of favorited books). Users can also leave reviews for the novels they've read.

### App Evaluation

- **Category:** Entertainment
- **Mobile:** It is great for quick searches and managing reading lists on-the-go.
- **Story:** It will allow for users to share their honest opinions on books they've read, and also keep note of books they would like to read.
- **Market:** This will be useful to students, book lovers, and the general public. 
- **Habit:** Could have a medium habit potential if people use it each time they want book recommendations. Habitual use can be encouraged with features like a checklist or reading goals.
- **Scope:** Could have a medium scope, book data will be pulled from public APIs, favorites, and review systems.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can browse books
* User can search for a book
* User can favorite a book
* User can view list of favorited books
* User can select a book to view its details
* User can write a review for a book
* User can add books to reading-list
* User can delete & check off books from reading-list

**Optional Nice-to-have Stories**

* User can sign up / login
* User can view author profiles
* User can follow authors
* User will have their own profile
* Users can message each other

### 2. Screen Archetypes

- Home Screen
    - User can view list of books
    - Search bar and filters
    - User can favorite books
- Book Details
    - User can view the book details
    - User can write a review
    - User can favorite the book
    - User can add the book to their reading list
- Reading List
    - User can view their reading list
    - User can check off the book as completed
    - User can delete book from list
- Favorites Page
    - User can view favorited books
    - User can remove book from favorites

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Home Page
* Reading List
* Favorites Page

**Flow Navigation** (Screen to Screen)

- Home
    -> Book Details
- Book Details
    -> Home
- Favorites Page
    -> Book Details
- Reading List
    -> Book Details
