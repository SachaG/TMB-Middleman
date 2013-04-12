$(function(){
  $('body').addClass('animate');
  $('#origin').val(document.referrer);
  $('#landing').val(document.title);
  $('.pullcenter img').click(function(){
    var $this=$(this);
    $('#lightbox').removeClass('hide').find('img').attr('src', $this.attr('src'));
  });
  $('#lightbox').click(function(){
    $(this).addClass('hide');
  });

  $('.lines-highlight').each(function(){
    var $this = $(this);
    var linesToHighlight = $this.attr('data-lines');
    var highlightClass = $this.attr('data-class')
    var linesArray = linesToHighlight.split(',');
    var rangesArray = [];
    var finalArray = [];

    // looping from the end makes it possible to splice from within the loop without reindexing problems
    //http://stackoverflow.com/questions/9882284/looping-through-array-and-removing-items-without-breaking-for-loop
    var length = linesArray.length;
    while(length--){
      index = length;
      element = linesArray[index];
      if(typeof element === 'string'){
        var range = element.split('~');
        if(range.length > 1){
          var lowerBound = parseInt(range[0]);
          var upperBound = parseInt(range[1]);
          // initialize empty array for this range, and fill it
          rangeArray = [];
          for (var i = lowerBound; i <= upperBound; i++) {
            rangeArray.push(i);
          }
          // add range to array of ranges
          rangesArray.push(rangeArray);
          linesArray.splice(index,1);
        }else{
          linesArray[index] = parseInt(linesArray[index]);
        }
      }
    }

    // concat
    finalArray = linesArray.concat(rangesArray)
    // flatten and sort
    // http://stackoverflow.com/questions/10865025/merge-flatten-an-array-of-arrays-in-javascript
    finalArray= [].concat.apply([], finalArray);
    finalArray.sort(function(a,b){return a-b});

    var $pre = $this.prevAll('.highlight').first().find('pre');
    var text = $pre.html();
    var lines = text.split('\n');

    // block level elements
    $.each(lines, function(index, line){
      console.log(index+1, finalArray)
      if($.inArray(index+1, finalArray) == -1){
        lines[index] = '<span class="line">' + lines[index] + '</span>'
      }else{
        lines[index] = '<span class="line highlighted '+highlightClass+'">' + lines[index] + '</span>'
      }
    });
    $pre.html(lines.join(""));

    // inline elements
    // $.each(finalArray, function(index, line){
    //   number = line-1;
    //   lines[number] = '<span class="highlighted '+highlightClass+'">' + lines[number] + '</span>';
    // });
    // $pre.html(lines.join("\n"));
  });
});
