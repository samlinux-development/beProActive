
import fs from 'fs';
import path from 'path';
import matter from 'gray-matter';
import { marked } from 'marked';

const formatDate = (blogDate) => {
  const date = new Date(blogDate);
  return date.toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  });
}

function getPosts(){
  const postsDirectory = path.join(process.cwd(), 'content');
  const filenames = fs.readdirSync(postsDirectory);

  const posts = filenames.map((filename) => {
    // if file is md file
    if (!filename.endsWith('.md')) {
      return;
    }
    const filePath = path.join(postsDirectory, filename);
    const fileContents = fs.readFileSync(filePath, 'utf8');
    const { data, content } = matter(fileContents);
   
    return {
      title: data.title,
      date: formatDate(data.date),
      content: marked.parse(content),
      slug: filename.replace(/\.md$/, ''),
    };
  });
  //console.log(posts)
  return posts;
}

const jsonPosts = getPosts();

// sort post by date
jsonPosts.sort((a, b) => {
  if (a.date < b.date) {
    return 1;
  } else {
    return -1;
  }
});
// write jsonPosts to content.json file
fs.writeFileSync('src/data/content.json', JSON.stringify(jsonPosts));


