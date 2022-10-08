from PropBank.FramesetList cimport FramesetList
from AnnotatedSentence.AnnotatedSentence cimport AnnotatedSentence
from AnnotatedSentence.AnnotatedWord cimport AnnotatedWord
from SemanticRoleLabeling.AutoProcessor.Sentence.Propbank.SentenceAutoPredicate cimport SentenceAutoPredicate


cdef class TurkishSentenceAutoPredicate(SentenceAutoPredicate):

    cdef FramesetList __frameset_list

    def __init__(self, framesetList: FramesetList):
        """
        Constructor for TurkishSentenceAutoPredicate. Gets the FrameSets as input from the user, and sets
        the corresponding attribute.

        PARAMETERS
        ----------
        framesetList : FramesetList
            FramesetList containing the Turkish propbank frames.
        """
        self.__frameset_list = framesetList

    cpdef bint autoPredicate(self, AnnotatedSentence sentence):
        """
        The method uses predicateCandidates method to predict possible predicates. For each candidate, it sets for that
        word PREDICATE tag.

        PARAMETERS
        ----------
        sentence : AnnotatedSentence
            The sentence for which predicates will be determined automatically.

        RETURNS
        -------
        bool
            If at least one word has been tagged, true; false otherwise.
        """
        cdef list candidate_list
        cdef AnnotatedWord word
        candidate_list = sentence.predicateCandidates(self.__frameset_list)
        for word in candidate_list:
            if isinstance(word, AnnotatedWord):
                word.setArgument("PREDICATE$" + word.getSemantic())
        if len(candidate_list) > 0:
            return True
        return False
