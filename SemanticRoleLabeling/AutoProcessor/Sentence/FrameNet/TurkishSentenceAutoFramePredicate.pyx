from FrameNet.FrameNet cimport FrameNet

from AnnotatedSentence.AnnotatedSentence cimport AnnotatedSentence
from AnnotatedSentence.AnnotatedWord cimport AnnotatedWord
from SemanticRoleLabeling.AutoProcessor.Sentence.FrameNet.SentenceAutoFramePredicate cimport SentenceAutoFramePredicate

cdef class TurkishSentenceAutoFramePredicate(SentenceAutoFramePredicate):

    cdef FrameNet __frame_net

    def __init__(self, frameNet: FrameNet):
        """
        Constructor for TurkishSentenceAutoFramePredicate. Gets the Frames as input from the user, and sets
        the corresponding attribute.

        PARAMETERS
        ----------
        frameNet : FrameNet
            FrameNet containing the Turkish frameNet frames.
        """
        self.__frame_net = frameNet

    cpdef bint autoPredicate(self, AnnotatedSentence sentence):
        """
        The method uses predicateFrameCandidates method to predict possible predicates. For each candidate, it sets for that
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
        candidate_list = sentence.predicateFrameCandidates(self.__frame_net)
        for word in candidate_list:
            if isinstance(word, AnnotatedWord):
                word.setArgument("PREDICATE$NONE$" + word.getSemantic())
        if len(candidate_list) > 0:
            return True
        return False
