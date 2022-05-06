class Contact:
    """
    Represents contact information of every user registered in the system.
    """

    email: str
    phone: str
    portifolio: str


class User:
    """
    Represents a user registered in the system.
    """

    userId: int
    firstName: str
    lastName: str
    hashed_password: str
    title: str
    affiliation: str
    contactInfo: Contact

    def reset_password(self, new_hashed_password: str) -> None:
        # resets password for a user
        self.hashed_password = new_hashed_password

    def getSubmittedPapers(self):
        # returns a list of papers submitted by a user
        query = "SELECT * FROM papers WHERE authorId = self.userId"
        return [Paper(**row) for row in self.db.query(query)]

    def getReviewedPapers(self):
        # returns a list of papers reviewed by a user
        query = "SELECT * FROM papers WHERE authorId = self.userId"
        return [Paper(**row) for row in self.db.query(query)]

    def registerAsAuthor(self, confid):
        # registers a user as an author
        query = "INSERT INTO authors (userId,confid) VALUES (self.userId,confid)"
        self.db.query(query)
        return Author(
            self.userId,
            self.firstName,
            self.lastName,
            self.title,
            self.affiliation,
            self.contactInfo,
            confid,
        )

    def registerAsReviewer(self, confid):
        # registers a user as a reviewer
        query = "INSERT INTO reviewers (userId,confid) VALUES (self.userId,confid)"
        self.db.query(query)
        return Reviewer(
            self.userId,
            self.firstName,
            self.lastName,
            self.title,
            self.affiliation,
            self.contactInfo,
            confid,
        )

    def registerAsChair(self, confid):
        # registers a user as a chair
        query = "INSERT INTO chairs (userId,confid) VALUES (self.userId,confid)"
        self.db.query(query)
        return Chair(
            self.userId,
            self.firstName,
            self.lastName,
            self.title,
            self.affiliation,
            self.contactInfo,
            confid,
        )


class Admin(User):
    """
    Represents an admin in the system.
    """

    def approveConference(self, conf: Conference):
        # approve and add conf to db
        return conf


class Chair(User):
    """
    Represents user registered as a chair in a conference
    """

    conferenceId: int

    def selectReviewers(self) -> List[Reviewer]:
        # selects reviewers for a paper
        pass

    def assignReviewers(self) -> List[Reviewer]:
        # assigns reviewers to a paper
        pass

    def sendNotifications(self):
        # sends notifications to reviewers
        pass


class Author(User):
    """
    Represents users who are registered as authors in a conference.
    """

    conferenceId: int

    def submitPaper(Paper):
        # submits a paper for a conference
        pass

    def getSubmittedPapers(self):
        # returns submitted papers for this conference
        query = "SELECT * FROM papers WHERE authorId = self.userId AND conferenceId = self.conferenceId"
        return [Paper(**row) for row in self.db.query(query)]


class Reviewer(User):
    """
    Represents users who are registered as reviewers in a conference
    """

    conferenceId: int
    isSelected: bool = False

    def getAllocatedPapers(self):
        # returns a list of papers allocated to a reviewer
        query = "SELECT * FROM papers WHERE reviewerId = self.userId AND conferenceId = self.conferenceId"
        return [Paper(**row) for row in self.db.query(query)]

    def submitReview(self, paperId):
        # submits a review for a paper
        allocated_papers = self.getAllocatedPapers()
        if paperId in allocated_papers:
            pass

    def getReview(paperid) -> str:
        # returns a review for a paper

        # check if paperid is in allocated papers of the conference
        query = "SELECT * FROM reviews WHERE paperId = paperId AND conferenceId = self.conferenceId AND reviewerId = self.userId"
        return query


class Paper:
    """
    Represents a paper submitted in a conference.
    """

    paperId: int
    Title: str
    Authors: List[Author]
    Abstract: str
    KeyWords: str
    Manuscript: str
    isAccepted: bool = False

    def getAllocatedReviewers(self) -> List[Reviewer]:
        # returns a list of reviewers allocated to a paper
        query = "SELECT * FROM reviewers WHERE paperId = self.paperId"
        return [Reviewer(**row) for row in self.db.query(query)]

    def getReviews(self) -> List[str]:
        # returns a list of reviews for a paper
        reviewers = self.getAllocatedReviewers(db)
        return [reviewer.getReview(self.paperId) for reviewer in reviewers]


class AcceptedPaper(Paper):
    """
    Represents a paper submitted in a conference and is accepted.
    """

    DOI: str
    FinalManuscript: str
    Copyright: str

    def submitCamReadySubmission(self):
        # submits a camera ready submission for a paper
        pass


class Deadlines:
    """
    Represents deadlines for a conference.
    """

    date: Date
    message: str
    isAuthor: bool  # if Reviewer False else True


class Conference:
    """
    Represents a conference entity in the system.
    """

    conferenceId: int
    chairPerson: Chair
    conferenceName: str
    conferenceURL: str
    ongoing: bool
    isApproved: bool
    conferenceDeadlines: List[Deadlines]

    def getRegisteredAuthors(self) -> List[int]:
        # returns a list of authors registered in a conference
        authorIds = (
            "SELECT authorId FROM authors WHERE conferenceId = self.conferenceId"
        )
        return authorIds

    def getRegisteredReviewers(db) -> List[int]:
        # returns a list of reviewers registered in a conference
        reviewerIds = (
            "SELECT reviewerId FROM reviewers WHERE conferenceId = self.conferenceId"
        )
        return db.query(reviewerIds)

    def getFinalReviewers(db) -> List[int]:
        # returns a list of reviewers who are selected as final reviewers
        finalReviewerIds = "SELECT finalReviewers FROM reviewers WHERE conferenceId = self.conferenceId AND isSelected = True"
        return db.query(finalReviewerIds)

    def getSubmittedPapers(self) -> List[int]:
        # returns a list of papers submitted in a conference
        submittedPaperIds = (
            "SELECT submittedPapers FROM papers WHERE conferenceId = self.conferenceId"
        )
        return db.query(submittedPaperIds)

    def getAcceptedPapers(self) -> List[int]:
        # returns a list of papers accepted in a conference
        acceptedPaperIds = "SELECT acceptedPapers FROM papers WHERE conferenceId = self.conferenceId AND isAccepted = True"
        return db.query(acceptedPaperIds)


def Main():
    conf_user_details = get_conf_and_user_details()
    reviewer_assignment_allocation(conf=None)
    output_data()


def get_conf_and_user_details():
    # get conference and user details
    validated_user = user_account_details()
    if is_registered_author(validated_user.userId, confId=None):
        author = Author(
            validated_user.userId,
            validated_user.firstName,
            validated_user.lastName,
            validated_user.title,
            validated_user.affiliation,
            validated_user.contactInfo,
            confId=None,
        )
        paper = paper_submission(author)
    if is_registered_reviewer(validated_user.userId, confId=None):
        reviewer = Reviewer(
            validated_user.userId,
            validated_user.firstName,
            validated_user.lastName,
            validated_user.title,
            validated_user.affiliation,
            validated_user.contactInfo,
            confId=None,
        )
        review = review_submission(reviewer)

    validated_conf_info = conference_details(admin=None)
    cam_ready = camera_ready_submission(acceptedPaper=None)
    return validated_user, validated_conf_info, paper, review, cam_ready


def is_registered_author(userId, confId) -> bool:
    # check if user is registered as an author in the conference
    query = "SELECT * FROM authors WHERE userId = {userId} AND conferenceId = {confId}"
    return True if query else False


def is_registered_reviewer(userId, confId) -> bool:
    # check if user is registered as a reviewer in the conference
    query = (
        "SELECT * FROM reviewers WHERE userId = {userId} AND conferenceId = {confId}"
    )
    return True if query else False


def user_account_details() -> User:
    # get user details
    validated_credentials = validate_user_account_details()
    query = "..."
    return User(**query)


def validate_user_account_details():
    # validate user credentials
    credentials = get_login_credentials()
    # validate credentials using db query
    return validated_credentials


def get_login_credentials():
    # get login credentials

    # get credentials from user as input
    login_credentials = input()
    return login_credentials


def conference_details(admin: Admin):
    # get conference details
    return approve_conference_details(admin)


def approve_conference_details(admin: Admin):
    # asks admin to approve the conference
    conf_info = get_conference_details()
    # validate conference details using db query
    return admin.approveConference(conf_info)


def get_conference_details() -> Conference:
    # get conference details from conference object
    conference_info = input()
    return Conference(**conference_info)


def paper_submission(author: Author):
    # get paper details from author and submit paper
    return author.submitPaper(Paper)


def review_submission(review: Reviewer, paper: Paper):
    # get review details from reviewer and submit review
    return review.submitReview(paper.paperId)


def camera_ready_submission(paper: AcceptedPaper):
    # get camera ready details from author and submit camera ready submission
    return paper.submitCamReadySubmission()


def reviewer_assignment_allocation(conf: Conference):
    # get final reviewers and assign reviewers to papers
    selected_reviewers = reviewer_selection(conf.chairPerson)
    reviewer_paper_mapping = paper_allocation_to_reviewer(conf)


def reviewer_selection(chair: Chair):
    # chair selects the final reviewers
    return chair.selectReviewers()


def paper_allocation_to_reviewer(conf: Conference):
    # Algorithm maps papers to reviewers
    mapping = map_papers_to_reviewers(
        conf.getSubmittedPapers(), conf.getFinalReviewers()
    )
    # add mapping details to database


def map_papers_to_reviewers(
    submittedPapers: List[Paper], finalReviewers: List[Reviewer]
):
    # Algorithm maps papers to reviewers
    return {
        paper: reviewers
        for paper, reviewers in preference(submittedPapers, finalReviewers)
    }


def output_data():
    acceptanceStatus = paper_acceptance_decision(paper=None)
    display_reviews(paper=None)
    notifications(conf=None)


def paper_acceptance_decision(paper: Paper):
    # Algorithm decides whether paper is accepted or not based on reviews and other factors
    acceptanceStatus = paper_acceptance_algorithm(paper.getReviews())
    # Inserts the decison into the database
    return acceptanceStatus


def paper_acceptance_algorithm(reviews: List[str]):
    # Algorithm decides whether paper is accepted or not based on reviews and other factors
    return Union[True, False]


def display_reviews(paper: Paper):
    # Algorithm displays reviews for a paper
    reviews = paper.getReviews()
    # displays reviews on UI using UI framework


def notifications(conf: Conference):
    # Algorithm sends notifications to authors and reviewers

    authors = conf.getRegisteredAuthors()
    reviewers = conf.getFinalReviewers()
    # Algorithm sends notifications to authors and reviewers
    deadlines = conf.conferenceDeadlines()
    for (date, msg, isAuthor) in deadlines:
        if isAuthor:
            schedule_notification(date, msg, authors)
        else:
            schedule_notification(date, msg, reviewers)
